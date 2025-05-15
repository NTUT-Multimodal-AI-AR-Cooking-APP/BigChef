import SwiftUI

struct ContentView: View {
    @State private var stepText: String = ""
    @State private var submittedStep: String = ""

    var body: some View {
        ZStack {
            CookingARView(step: $submittedStep)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    TextField("輸入烹飪步驟", text: $stepText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("送出") {
                        let current = stepText
                        submittedStep = ""
                        submittedStep = current
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
