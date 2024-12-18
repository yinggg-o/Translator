import Cocoa
import SwiftUI
import Alamofire



// 登录视图结构体
struct LoginView: View {
    // 根据状态变量切换显示登录视图、注册视图或重置密码视图
    @State private var showView: String = "login"
    @EnvironmentObject var userLoginStatus: UserLoginStatus

    var body: some View {
        if userLoginStatus.isLoggedIn {
            HomeView()
        } else {
            HStack {
                // 左侧图片和文字部分
                VStack {
                    Image("login")
                 .resizable()
                 .aspectRatio(contentMode:.fit)
                 .frame(width: 250)
                 .padding()
                }
             .frame(width: 300)
                Divider()
                // 根据状态变量切换显示登录视图、注册视图或重置密码视图
                if showView == "login" {
                    Login(onRegister: {
                        self.showView = "register"
                    }, onResetPassword: {
                        self.showView = "resetPassword"
                    })
                } else if showView == "register" {
                    RegisterView(onLogin: {
                        self.showView = "login"
                    })
                } else {
                    ResetPasswordView(onLogin: {
                        self.showView = "login"
                    })
                }
            }
         .background(Color.white)
         .frame(maxWidth: 649, maxHeight: 400)
         .onAppear {
                checkLoginStatus()
            }
        }
    }

    func checkLoginStatus() {
        if let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool, isLoggedIn {
            userLoginStatus.isLoggedIn = true
            if let tokenName = UserDefaults.standard.string(forKey: "tokenName") {
                userLoginStatus.tokenName = tokenName
            }
            if let tokenValue = UserDefaults.standard.string(forKey: "tokenValue") {
                userLoginStatus.tokenValue = tokenValue
            }
            if let loginId = UserDefaults.standard.object(forKey: "loginId") as? Int {
                userLoginStatus.loginId = loginId
            }
        } else {
            userLoginStatus.isLoggedIn = false
            userLoginStatus.loginId = nil
            userLoginStatus.tokenName = nil
            userLoginStatus.tokenValue = nil
        }
    }
}

// 登录相关逻辑的视图结构体
struct Login: View {
    @StateObject var captchaManager = CaptchaManager()
    var onRegister: () -> Void
    var onResetPassword: () -> Void
    @EnvironmentObject var userLoginStatus: UserLoginStatus
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
                // 显示验证码图片的按钮，根据captchaManager.captchaImage是否有值来决定显示图片还是占位文本
                if let image = captchaManager.captchaImage {
                    image
                    .resizable()
                    .frame(width: 80, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .onTapGesture {
                            // 点击验证码图片后重新获取验证码
                            captchaManager.getImageCode()
                        }
                } else {
                    Text("验证码")
                }
            }
            .padding(.bottom, 10)
            HStack {
                Button("忘记密码") {
                    // 忘记密码逻辑
                    self.onResetPassword()
                }
                .foregroundColor(.blue)
                Spacer()
                Button("注册账户") {
                    // 注册账户逻辑
                    self.onRegister()
                }
                .foregroundColor(.blue)
            }
            Button("登录") {
                // 这里可以使用username、password和verificationCode变量
                print("账户名: \(username)")
                print("密码: \(password)")
                print("验证码: \(verificationCode)")
                if verificationCode == ""{
                    print("验证码未输入")
                    return
                }
                if captchaManager.captchaCode != verificationCode {
                    print("验证码错误")
                    return
                }
                let parameters: [String: Any] = [
                    "username": username,
                    "password": password,
                    "imgcode": verificationCode,
                    "uuid": captchaManager.captchaKey
                ]
                login(with: parameters)
            }
            .padding()
            .frame(width: 300, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .buttonStyle(PlainButtonStyle())

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
        .onAppear() {
                captchaManager.getImageCode()
            }
    }

    func login(with parameters: [String: Any]) {
        AF.request(APIConfigManager.shared.loginEndpoint, method:.post, parameters: parameters, encoding: JSONEncoding.default)
         .responseJSON { response in
                switch response.result {
                case.success(let value):
                    if let jsonDict = value as? [String: Any],
                       let code = jsonDict["code"] as? Int,
                       let msg = jsonDict["msg"] as? String {
                        if code == 200 {
                            // 登录成功
                            if let data = jsonDict["data"] as? [String: Any],
                                let tokenName = data["tokenName"] as? String,
                                let tokenValue = data["tokenValue"] as? String,
                                let loginIdString = data["loginId"] as? String,
                                let loginId = Int(loginIdString) {  // 将获取到的字符串类型的loginId转换为Int类型
                                // 保存登录状态和用户信息
                                print(data)
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                UserDefaults.standard.set(tokenName, forKey: "tokenName")
                                UserDefaults.standard.set(tokenValue, forKey: "tokenValue")
                                UserDefaults.standard.set(loginId, forKey: "loginId")
                                
                                // 更新用户登录状态
                                DispatchQueue.main.async {
                                    userLoginStatus.isLoggedIn = true
                                    userLoginStatus.tokenName = tokenName
                                    userLoginStatus.tokenValue = tokenValue
                                    userLoginStatus.loginId = loginId
                                }
                                
                            }
                            print("登录成功")
                        } else {
                            // 登录失败
                            print("登录失败: \(msg)")
                        }
                    }
                case.failure(let error):
                    print("网络请求失败: \(error)")
                }
            }
    }
}



// 预览视图提供器
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        let userLoginStatus = UserLoginStatus()
        return LoginView()
     .environmentObject(userLoginStatus)
    }
}
