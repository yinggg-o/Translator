//
//  ContentView.swift
//  Translator
//
//  Created by suhm on 2024/11/24.
//

import SwiftUI


struct TranslatorView: View {
    // 根据状态变量切换显示登录视图或注册视图
    @State private var showLoginView = true
    var body: some View {
        HStack {
            // 左侧图片和文字部分
            VStack {
                Image("login")
                 .resizable()
                 .aspectRatio(contentMode:.fit)
                 .frame(width: 250)
                 .padding()
            }
            // 根据状态变量切换显示登录视图或注册视图
//            LoginView()
            if showLoginView {
                LoginView(onRegister: {
                    self.showLoginView = false
                })
            } else {
                RegisterView(onLogin: {
                    self.showLoginView = true
                })
            }
        }
     .background(Color.white)
     .frame(maxWidth:900,maxHeight: 500)
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorView()
    }
}
}
