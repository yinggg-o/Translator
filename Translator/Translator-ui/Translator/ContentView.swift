import SwiftUI
import NavigationStack


struct TranslatorView: View {
    @EnvironmentObject var userLoginStatus: UserLoginStatus

    var body: some View {
        NavigationStackView {
           
            if userLoginStatus.isLoggedIn {
                HomeView()
            } else {
                LoginView()
                
            }
        }
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        let userLoginStatus = UserLoginStatus()
        return TranslatorView()
         .environmentObject(userLoginStatus)
    }
}
