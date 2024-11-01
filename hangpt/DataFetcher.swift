import SwiftUI
import Combine


class DataFetcher: ObservableObject {
    @Published var breedData: [BreedData] = []
    @Published var breedGroupData: [BreedGroupData] = []
    
    func fetchData() {
        guard let url = URL(string: "https://67fc-70-126-30-23.ngrok-free.app/api/dog-breed-data") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(DogBreedResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.breedData = result.breedData
                        self.breedGroupData = result.breedGroupData
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}

// Root response structure
struct DogBreedResponse: Codable {
    let breedData: [BreedData]
    let breedGroupData: [BreedGroupData]

    enum CodingKeys: String, CodingKey {
        case breedData = "breed_data"
        case breedGroupData = "breed_group_data"
    }
}

struct BreedStat: Codable {
    let _id: String
    let count: Int
}

struct BreedGroupStat: Codable {
    let _id: String
    let count: Int
}
