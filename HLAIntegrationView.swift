import SwiftUI
import HealthKit

/// Example SwiftUI view that lets you save an HLA allele to HealthKit
struct HLAIntegrationView: View {
    @EnvironmentObject var healthKit: HealthKitManager
    @State private var allele: String = "B*57:01"
    @State private var loincCode: String = "51992-0"
    @State private var saveResult: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("HLA Integration with HealthKit")
                .font(.headline)

            TextField("Allele (e.g. B*57:01)", text: $allele)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("LOINC Code (e.g. 51992-0)", text: $loincCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Save to Health") {
                healthKit.saveHLAType(allele, loincCode: loincCode) { success, error in
                    if success {
                        saveResult = "Saved: \(allele) (LOINC \(loincCode))"
                    } else if let error = error {
                        saveResult = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            if !saveResult.isEmpty {
                Text(saveResult)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}

#if DEBUG
struct HLAIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        HLAIntegrationView()
            .environmentObject(HealthKitManager.shared)
    }
}
#endif
