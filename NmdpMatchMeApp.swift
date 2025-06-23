import SwiftUI

@main
struct NmdpMatchMeApp: App {
    // Use the shared HealthKit manager
    @StateObject private var healthKit = HealthKitManager.shared

    var body: some Scene {
        WindowGroup {
            // Your root view(s) here
            MatchLikelihoodView()
                // Ask for permissions when the app launches
                .onAppear {
                    healthKit.requestHealthKitPermissions { success, error in
                        if let error = error {
                            print("HealthKit auth error: \(error)")
                        }
                    }
                }
                .environmentObject(healthKit)
        }
    }
}
