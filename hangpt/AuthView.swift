import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var isLogin = true

    var body: some View {
        VStack {
            Text(isLogin ? "Login" : "Register")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if isLogin {
                    viewModel.login(username: username, password: password)
                } else {
                    viewModel.register(username: username, password: password)
                }
            }) {
                Text(isLogin ? "Login" : "Register")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }

            Text(viewModel.authMessage)
                .padding()
                .foregroundColor(viewModel.isAuthenticated ? .green : .red)

            Button(action: {
                isLogin.toggle()
            }) {
                Text(isLogin ? "Don't have an account? Register" : "Already have an account? Login")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}
