import SwiftUI

@main
struct TranslatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            // Disable the close, minimize, and zoom buttons
            CommandGroup(replacing: .appTermination) { }
        }
    }
}

struct FloatingWindowApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

