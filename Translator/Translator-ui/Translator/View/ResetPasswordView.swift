import SwiftUI
import Foundation
import Translator  // 添加 Translator 模块导入


// 重置密码视图
struct ResetPasswordView: View {
    @State private var username = ""  // 将 phoneNumber 改为 username
    @State private var smscode = ""  // 将 verificationCode 改为 smscode
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var imgcode = ""  // 将 imagecode 改为 imgcode
    @State private var errorMessage: String?
    @State private var isLoading = false

    @StateObject private var captchaManager = CaptchaManager() // 添加 CaptchaManager 实例

    // 用于接收控制视图切换的变量
    var onLogin: () -> Void

    var body: some View {
        VStack(alignment:.leading) {
            Text("Reset Password")
                .font(.title)
                .padding(.bottom, 15)
                .padding(.top, 20)
                .frame(maxWidth:.infinity, alignment:.center)
            TextField("手机号码", text: $username)  // 更新绑定变量
                .padding()
                .frame(height: 40)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            HStack {
                TextField("验证码输入", text: $smscode)  // 更新绑定变量
                    .padding()
                    .frame(height: 30)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .foregroundColor(Color.gray)
                Button("发送验证码") {
                    sendVerificationCode()
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 8)
                .background(Color.gray)
                .cornerRadius(5)
            }
            TextField("密码", text: $password)
                .padding()
                .frame(height: 30)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            TextField("确认密码", text: $confirmPassword)
                .padding()
                .frame(height: 30)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            HStack {
                if let image = captchaManager.captchaImage {
                    image
                        .resizable()
                        .frame(width: 80, height: 40)
                        .onTapGesture {
                            captchaManager.getImageCode() // 点击图片更新验证码
                        }
                } else {
                    Text("点击获取验证码")
                        .onTapGesture {
                            captchaManager.getImageCode() // 点击获取验证码
                        }
                }
                TextField("验证码", text: $imgcode)  // 更新绑定变量
                    .padding()
                    .frame(height: 30)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }

            Button("返回登录") {
                self.onLogin()
            }
            .foregroundColor(.blue)
            Button("确认修改") {
                resetPassword()
            }
            .frame(width: 300, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .buttonStyle(PlainButtonStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Text("隐私协议")
                .foregroundColor(.blue)
                .padding(.top, 10)
                .frame(maxWidth:.infinity, alignment:.center)
        }
        .padding()
        .background(Color.white)
        .onAppear {
            captchaManager.getImageCode() // 页面加载时获取验证码
        }
    }

    private func sendVerificationCode() {
        guard !username.isEmpty else {  // 使用 username
            errorMessage = "请填写手机号"
            return
        }

        // 直接将 username 拼接到 URL 中
        let urlString = "\(APIConfigManager.shared.registerSendVerificationCode)?username=\(username)"
        guard let url = URL(string: urlString) else {
            errorMessage = "无效的 URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "发送验证码失败: \(error.localizedDescription)"
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // 验证码发送成功的处理逻辑
                    print("验证码发送成功")
                } else {
                    errorMessage = "发送验证码失败，请重试"
                }
            }
        }.resume()
    }

    private func resetPassword() {
        guard !username.isEmpty, !password.isEmpty, password == confirmPassword else {  // 使用 username
            errorMessage = "请确保所有字段都已填写且密码匹配"
            return
        }

        isLoading = true
        let url = URL(string: APIConfigManager.shared.updatePassword)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": username,  // 使用 username
            "password": password,
            "imgcode": imgcode,  // 使用 imgcode
            "uuid": captchaManager.captchaKey,
            "smscode": smscode  // 使用 smscode
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "重置密码失败: \(error.localizedDescription)"
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // 重置密码成功的处理逻辑
                    print("重置密码成功")
                } else {
                    errorMessage = "重置密码失败，请重试"
                }
            }
        }.resume()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(onLogin: {})
    }
}
