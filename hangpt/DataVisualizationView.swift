import SwiftUI
import Charts  // For SwiftUI's Charts framework
import Foundation

struct BreedData: Identifiable, Codable {
    var id: String { breed }
    let breed: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case breed = "_id"
        case count
    }
}

struct BreedGroupData: Identifiable, Codable {
    var id: String { breedGroup }
    let breedGroup: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case breedGroup = "_id"
        case count
    }
}

struct DogBreedData: Identifiable, Codable {
    let id: String  // Use MongoDB `_id` as String for Identifiable
    let breed: String
    let breedGroup: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case breed
        case breedGroup = "breed_group"
        case count
    }
}

enum ViewType: String, CaseIterable, Identifiable {
    case breed = "By Breed"
    case breedGroup = "By Breed Group"

    var id: String { self.rawValue }
}


enum ChartType: String, CaseIterable, Identifiable {
    case breed = "By Breed"
    case breedGroup = "By Breed Group"

    var id: String { self.rawValue }
}

// Pie chart view for displaying data
/*
struct PieChartView: View {
    let data: [(String, Int)]
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()

            Chart(data, id: \.0) { category, value in
                SectorMark(
                    angle: .value("Count", Double(value)),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(by: .value("Category", category))
            }
            .frame(height: 300)
            .chartLegend(.visible)
        }
        .padding()
    }
}*/

// View for showing data in a pie chart
struct PieChartView: View {
    let data: [(String, Int)]
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()

            Chart(data, id: \.0) { category, value in
                SectorMark(
                    angle: .value("Count", Double(value)),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(by: .value("Category", category))
            }
            .frame(height: 300)
            .chartLegend(.visible)
        }
        .padding()
    }
}

// Main data visualization view with a toggle between breed and breed group
struct DataVisualizationView: View {
    @StateObject private var dataFetcher = DataFetcher()
    @State private var selectedViewType: ViewType = .breed

    var displayedData: [(String, Int)] {
        switch selectedViewType {
        case .breed:
            return dataFetcher.breedData.map { ($0.breed, $0.count) }
        case .breedGroup:
            return dataFetcher.breedGroupData.map { ($0.breedGroup, $0.count) }
        }
    }

    var body: some View {
        VStack {
            Text("Which puppy was looked up most?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Picker("View by", selection: $selectedViewType) {
                ForEach(ViewType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            PieChartView(
                data: displayedData,
                title: selectedViewType == .breed ? "Most-searched Dog Breed" : "Most-searched Dog Breed Group"
            )
        }
        .onAppear {
            dataFetcher.fetchData()
        }
    }
}
