import SwiftUI

struct LegendView: View {
    let data: [(String, Int)]  // Takes the data with (name, count) format
    private let colors: [Color] = [.blue, .green, .orange, .purple, .red, .yellow, .gray]  // Colors for the chart segments

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<data.count, id: \.self) { index in
                HStack {
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 12, height: 12)
                    Text(data[index].0)  // Display the breed or breed group name
                        .font(.subheadline)
                    Spacer()
                    Text("\(data[index].1)")  // Display the count
                        .font(.subheadline)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
    }
}
