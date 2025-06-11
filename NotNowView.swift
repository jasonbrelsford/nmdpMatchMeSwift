
import SwiftUI

struct NotNowView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("🙌 Thanks for Staying In!")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)

            Text("We appreciate your continued interest in the registry. You remain an important part of our life-saving mission.")
                .multilineTextAlignment(.center)
                .padding()

            Text("We’ll reach out if a future opportunity arises where you're needed.")
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("Thank You")
    }
}