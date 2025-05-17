struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        Text("🏠 Home")
            .font(.largeTitle)
            .padding()
    }
}

final class HomeViewModel: ObservableObject { }