import SwiftUI

struct ContentView: View {
    @State private var showInputBox = false // State to control visibility of the input box
    @State private var inputText: String = "" // State to hold the input text

    var body: some View {
        VStack {
            // 'Translate' Button
            Button(action: {
                withAnimation {
                    showInputBox.toggle() // Toggle visibility of the input box
                }
            }) {
                Text("Translate")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.blue)
            }
            .padding()

            // The input box that is initially hidden
            if showInputBox {
                TextField("Enter text to translate...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 150) // Larger input box
                    .transition(.move(edge: .top)) // Animate the appearance
                    .animation(.easeInOut, value: showInputBox) // Smooth unfolding animation
            }

            // 'Flashcards' Button
            Button(action: {
                print("Flashcards tapped")
            }) {
                Text("Flashcards")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .frame(width: 400, height: showInputBox ? 400 : 200) // Adjust height dynamically
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

