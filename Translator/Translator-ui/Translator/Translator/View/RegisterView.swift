import SwiftUI

struct RegisterView: View {
    var onLogin: () -> Void
    // 在RegisterView内部定义数据模型相关变量
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var imageCode = ""

    var body: some View {
        // 使用自定义的注册视图，并正确传入环境对象实例
        VStack(alignment:.leading) {
            Text("Register")
               .font(.title)
               .padding(.bottom, 15)
               .padding(.top, 20)
               .frame(maxWidth:.infinity, alignment:.center)
            TextField("手机号", text: $phoneNumber)
               .padding()
               .frame(height: 30)
               .background(Color.white)
               .overlay(
                    RoundedRectangle(cornerRadius: 0)
                       .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
               .foregroundColor(Color.gray)
//                   .padding(.bottom, 5)
            HStack {
                TextField("验证码输入", text: $verificationCode)
                   .padding()
                   .frame(height: 30)
                   .background(Color.white)
                   .overlay(
                        RoundedRectangle(cornerRadius: 0)
                           .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                   .foregroundColor(Color.gray)
                Button("验证码") {
                    // 发送验证码逻辑
                }
               .padding(.horizontal, 5)
               .padding(.vertical, 8)
               .background(Color.gray.opacity(0.2))
               .cornerRadius(5)
            }
//               .padding(.bottom, 15)
            TextField("密码", text: $password)
               .padding()
               .frame(height: 30)
               .background(Color.white)
               .overlay(
                    RoundedRectangle(cornerRadius: 0)
                       .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
               .foregroundColor(Color.gray)
//                   .padding(.bottom, 15)
            TextField("确认密码", text: $confirmPassword)
               .padding()
               .frame(height: 30)
               .background(Color.white)
               .overlay(
                    RoundedRectangle(cornerRadius: 0)
                       .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
               .foregroundColor(Color.gray)
//                   .padding(.bottom, 15)
            HStack {
                TextField("图片码", text: $imageCode)
                   .padding()
                   .frame(height: 30)
                   .background(Color.white)
                   .overlay(
                        RoundedRectangle(cornerRadius: 0)
                           .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                   .foregroundColor(Color.gray)
                Button("验证码") {
                    // 发送验证码逻辑
                }
               .padding(.horizontal, 5)
               .padding(.vertical, 8)
               .background(Color.gray.opacity(0.2))
               .cornerRadius(5)

            }
            Button("返回登录") {
                // 返回登录逻辑
                self.onLogin()
            }
           .foregroundColor(.blue)
            Button("注册") {
                // 注册逻辑
            }
            .frame(width: 300, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .buttonStyle(PlainButtonStyle())

            Text("隐私协议")
               .foregroundColor(.blue)
               .padding(.top, 10)
               .frame(maxWidth:.infinity, alignment:.center)
        }
       .padding()
       .background(Color.white)
    }
}
