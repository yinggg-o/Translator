import SwiftUI

struct HomeView: View {
    // 状态变量，用于控制各个子视图的显示
    @State internal var showOptions = false
    @State internal var showTranslateView = false
    @State internal var showArticleManagementView = false
    @State internal var showWrongQuestionBookView = false

    // 环境对象，用于获取用户登录状态信息
    @EnvironmentObject var userLoginStatus: UserLoginStatus

    var body: some View {
        NavigationView {
            VStack {
                // 下半部分
                ZStack {
                    if showTranslateView {
                        TranslateView()
                    .transition(.slide)
                    .animation(.easeInOut)
                    } else if showArticleManagementView {
                        ArticleManagementView()
                    .transition(.slide)
                    .animation(.easeInOut)
                    } else if showWrongQuestionBookView {
                        WrongQuestionBookView()
                    .transition(.slide)
                    .animation(.easeInOut)
                    }
                }
                .background(Color.white)
//            .frame(minHeight: 500)
            }
            // 设置导航栏标题栏为空视图，以避免默认标题显示
         .navigationTitle(Text(""))
            // 使用toolbar修饰符来设置导航栏的内容
         .toolbar {
                // 设置在导航栏右侧的内容
                ToolbarItem(placement:.automatic) {
                    HStack(spacing: 15) {
                        // 显示用户昵称，从用户登录状态对象中获取昵称并设置样式
                        Text("昵称违规")
                    .font(.system(size: 16, weight:.medium))
                    .foregroundColor(.black)

                        Image("login-1")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray, lineWidth: 1)
                        )
                    .onTapGesture {
                            self.showOptions = !self.showOptions
                        }
                    .popover(isPresented: $showOptions, attachmentAnchor:.point(.bottom), arrowEdge:.bottom) {
                            OptionView(showOptions: $showOptions)
                        }

                        Menu {
                            Button("翻译") {
                                withAnimation {
                                    self.showTranslateView = true
                                    self.showArticleManagementView = false
                                    self.showWrongQuestionBookView = false
                                }
                            }
                            Button("文章管理") {
                                withAnimation {
                                    self.showArticleManagementView = true
                                    self.showTranslateView = false
                                    self.showWrongQuestionBookView = false
                                }
                            }
                            Button("翻译对比卡片") {
                                withAnimation {
                                    self.showWrongQuestionBookView = true
                                    self.showTranslateView = false
                                    self.showArticleManagementView = false
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                         .font(.title)
                        }
                    }
                }
            }
        .background(Color.white)
        }
    }
}

// 弹出选项视图结构体
struct OptionView: View {
    @EnvironmentObject var userLoginStatus: UserLoginStatus
    @Binding var showOptions: Bool

    var body: some View {
        VStack {
            Button("设  \t  置") {

            }
           .frame(width: 100)
           .overlay(
                RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.gray, lineWidth: 1)
            )
            Button("退出登录") {
                // 清除保存在UserDefaults中的登录相关信息
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "loginId")
                UserDefaults.standard.removeObject(forKey: "tokenName")
                UserDefaults.standard.removeObject(forKey: "tokenValue")

                // 将用户登录状态设置为未登录
                userLoginStatus.isLoggedIn = false
                userLoginStatus.loginId = nil
                userLoginStatus.tokenName = nil
                userLoginStatus.tokenValue = nil
            }
           .frame(width: 100)
           .overlay(
                RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.gray, lineWidth: 1)
            )
            Button("取  \t  止") {
                self.showOptions = false
            }
           .frame(width: 100)
           .overlay(
                RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.gray, lineWidth: 1)
            )
        }
       .padding()
       .background(Color.white)
       .cornerRadius(10)
       .shadow(radius: 5)
    }
}



// 以下是为了能在预览中看到效果添加的预览相关代码
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let userLoginStatus = UserLoginStatus()
        return HomeView()
       .environmentObject(userLoginStatus)
       .previewDisplayName("HomeView Preview")
       .previewDevice(PreviewDevice(rawValue: "MacBook Pro"))
       .previewInterfaceOrientation(.landscapeLeft)
       .environment(\.colorScheme, ColorScheme.light)
       .onAppear {
            let homeView = HomeView()
            homeView.showWrongQuestionBookView = false
        }
    }
}
