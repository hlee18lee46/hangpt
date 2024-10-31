import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LoginView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Login")
                }
            
            DogLookupView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Dog Lookup")
                }
            
            DataVisualizationView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Data Visualization")
                }
        }
    }
}
