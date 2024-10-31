struct DogInfo: Codable {
    let breed: String
    let breedGroup: String
    let commonHealthConcerns: [String]
    let energyLevel: String
    let height: String
    let lifespan: String
    let shedLevel: String
    let temperament: [String]
    let weight: String

    enum CodingKeys: String, CodingKey {
        case breed
        case breedGroup = "breed_group"
        case commonHealthConcerns = "common_health_concerns"
        case energyLevel = "energy_level"
        case height
        case lifespan
        case shedLevel = "shed_level"
        case temperament
        case weight
    }
}
