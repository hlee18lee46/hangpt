import SwiftUI
import PhotosUI

struct DogLookupView: View {
    @State private var apiResponse = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var dogInfo: DogInfo?

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            
            Button("Select Photo") {
                isPickerPresented = true
            }
            .padding()
            
            Button("Upload Image") {
                if let image = selectedImage {
                    uploadImage(image)
                } else {
                    apiResponse = "Please select an image first"
                }
            }
            .padding()
            
            if let dogInfo = dogInfo {
                VStack(alignment: .leading) {
                    Text("Breed: \(dogInfo.breed)")
                    Text("Breed Group: \(dogInfo.breedGroup)")
                    Text("Height: \(dogInfo.height)")
                    Text("Weight: \(dogInfo.weight)")
                    Text("Lifespan: \(dogInfo.lifespan)")
                    Text("Shed Level: \(dogInfo.shedLevel)")
                    Text("Temperament: \(dogInfo.temperament.joined(separator: ", "))")
                    Text("Energy Level: \(dogInfo.energyLevel)")
                    Text("Health Concerns: \(dogInfo.commonHealthConcerns.joined(separator: ", "))")
                }
                .padding()
            } else {
                Text("Response: \(apiResponse)")
                    .padding()
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    }
    
    func encodeImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        let base64String = imageData.base64EncodedString()
        print("Encoded Base64 String: \(base64String)") // Debugging: Print base64 string
        return base64String
    }
    


    func uploadImage(_ image: UIImage) {
        guard let url = URL(string: "https://67fc-70-126-30-23.ngrok-free.app/upload_and_analyze") else {
            apiResponse = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.8)!
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    apiResponse = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(DogInfo.self, from: data)
                    DispatchQueue.main.async {
                        dogInfo = decodedData
                        apiResponse = "Dog information received successfully!"
                    }
                } catch {
                    DispatchQueue.main.async {
                        apiResponse = "Failed to parse JSON response: \(error)"
                    }
                }
            }
        }.resume()
    }
}
