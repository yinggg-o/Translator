import SwiftUI
import Foundation
import Translator  // 确保导入Translator模块

struct RegisterView: View {
    var onLogin: () -> Void
    @State private var username = ""
    @State private var smscode = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var imgcode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @StateObject private var captchaManager = CaptchaManager()

    var body: some View {
        VStack(alignment:.leading) {
            Text("Register")
                .font(.title)
                .padding(.bottom, 15)
                .padding(.top, 20)
                .frame(maxWidth:.infinity, alignment:.center)
            TextField("手机号", text: $username)
                .padding()
                .frame(height: 30)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            HStack {
                TextField("验证码输入", text: $smscode)
                    .padding()
                    .frame(height: 30)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.5), lineWidth: 1))
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
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            TextField("确认密码", text: $confirmPassword)
                .padding()
                .frame(height: 30)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(Color.gray)
            HStack {
                if let image = captchaManager.captchaImage {
                    image
                        .resizable()
                        .frame(width: 80, height: 40)
                        .onTapGesture {
                            captchaManager.getImageCode()
                        }
                } else {
                    Text("点击获取验证码")
                        .onTapGesture {
                            captchaManager.getImageCode()
                        }
                }
                TextField("图片码", text: $imgcode)
                    .padding()
                    .frame(height: 30)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            Button("返回登录") {
                self.onLogin()
            }
            .foregroundColor(.blue)
            Button("注册") {
                registerUser()
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
            captchaManager.getImageCode()
        }
    }

    private func sendVerificationCode() {
        guard !username.isEmpty else {
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

    private func registerUser() {
        guard !username.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "请确保所有字段都已填写且密码匹配"
            return
        }

        isLoading = true
        let url = URL(string: APIConfigManager.shared.registerUser)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": username,
            "smscode": smscode.replacingOccurrences(of: "\t", with: ""),
            "password": password,
            "imgcode": imgcode,
            "uuid": captchaManager.captchaKey
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "注册失败: \(error.localizedDescription)"
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // 注册成功的处理逻辑
                    print("注册成功")
                } else {
                    errorMessage = "注册失败，请重试"
                }
            }
        }.resume()
    }
}

struct RegisterView1: PreviewProvider {
    static var previews: some View {
        RegisterView(onLogin: {})
    }
}
