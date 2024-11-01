import Foundation


// Define user data structure
struct User: Codable {
    let username: String
    let password: String
}

struct AuthResponse: Codable {
    let message: String
}

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authMessage = ""

    private let baseURL = "https://67fc-70-126-30-23.ngrok-free.app" // Replace with your ngrok URL

    func register(username: String, password: String) {
        let user = User(username: username, password: password)
        guard let url = URL(string: "\(baseURL)/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.authMessage = "No data received"
                    return
                }
                
                if let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                    self.authMessage = authResponse.message
                } else {
                    self.authMessage = "Failed to parse response"
                }
            }
        }.resume()
    }

    func login(username: String, password: String) {
        let user = User(username: username, password: password)
        guard let url = URL(string: "\(baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.authMessage = "No data received"
                    return
                }
                
                if let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                    self.authMessage = authResponse.message
                    self.isAuthenticated = authResponse.message == "Login successful"
                } else {
                    self.authMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
}
