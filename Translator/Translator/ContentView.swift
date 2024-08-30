import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Floating Window")
                .font(.title)
                .padding()
            Button("Close") {
                NSApp.terminate(nil)
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

