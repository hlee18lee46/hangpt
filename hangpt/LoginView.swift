import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login Feature")
                .font(.largeTitle)
                .padding()
            Button("Login") {
                // Implement login logic here
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
