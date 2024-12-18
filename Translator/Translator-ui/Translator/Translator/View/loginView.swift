//
//  LoginView.swift
//  Translator
//
//  Created by suhm on 2024/11/24.
//

import SwiftUI

struct LoginView: View {
    var onRegister: () -> Void
    @State private var username = ""
    @State private var password = ""
    @State private var verificationCode = ""
    var body: some View {
        // 右侧登录部分
        VStack(alignment:.leading) {
            Text("Login")
               .font(.title)
               .padding(.bottom, 20)
               .frame(maxWidth:.infinity, alignment:.center)
            TextField("账户名", text: $username) // 绑定username变量
               .padding()
               .frame(height: 40)
               .background(Color.white)
               .overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
               .foregroundColor(Color.gray)
               .padding(.bottom, 10)
            TextField("密码", text: $password) // 绑定password变量
               .padding()
               .frame(height: 40)
               .background(Color.white)
               .overlay(
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
               .foregroundColor(Color.gray)
               .padding(.bottom, 10)
            HStack {
                TextField("验证码输入", text: $verificationCode) // 绑定verificationCode变量
                   .padding()
                   .frame(height: 40)
                   .background(Color.white)
                   .overlay(
                        RoundedRectangle(cornerRadius: 5)
                           .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                   .foregroundColor(Color.gray)
                Button("验证码") {
                    // 发送验证码逻辑
                }
               .padding(.horizontal, 10)
               .padding(.vertical, 8)
               .background(Color.gray.opacity(0.2))
               .cornerRadius(5)
            }
           .padding(.bottom, 10)
            Button("登录") {
                // 这里可以使用username、password和verificationCode变量
                print("账户名: \(username)")
                print("密码: \(password)")
                print("验证码: \(verificationCode)")
            }
            .padding()
            .frame(width: 300, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .buttonStyle(PlainButtonStyle())
            HStack {
                Button("忘记密码") {
                    // 忘记密码逻辑
                }
               .foregroundColor(.blue)
                Spacer()
                Button("注册账户") {
                    // 注册账户逻辑
                    self.onRegister()
                }
               .foregroundColor(.blue)
            }
           .padding(.top, 10)
            HStack {
                ForEach(0..<3) { _ in
                    Circle()
                       .frame(width: 10, height: 10)
                       .foregroundColor(Color.gray.opacity(0.5))
                       .padding(.horizontal, 2)
                }
            }
           .padding(.top, 10)
            Text("隐私协议")
               .foregroundColor(.blue)
               .padding(.top, 10)
               .frame(maxWidth:.infinity, alignment:.center)
        }
       .padding()
       .background(Color.white)
    }
}
