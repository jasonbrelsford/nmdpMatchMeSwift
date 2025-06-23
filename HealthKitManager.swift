import Foundation
import HealthKit
import Combine

/// Singleton manager for HealthKit interactions
final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    /// Request authorization to write and read the sample type we’ll use for HLA.
    func requestHealthKitPermissions(completion: ((Bool, Error?) -> Void)? = nil) {
        // We’ll write and read a QuantityType (using bodyTemperature as a placeholder)
        guard let sampleType = HKObjectType.quantityType(
                forIdentifier: .bodyTemperature
        ) else {
            completion?(false, nil)
            return
        }

        healthStore.requestAuthorization(toShare: [sampleType], read: [sampleType]) { success, error in
            DispatchQueue.main.async {
                completion?(success, error)
            }
        }
    }

    /// Save an HLA allele sample with a LOINC code into HealthKit.
    func saveHLAType(_ allele: String,
                     loincCode: String,
                     recordedAt date: Date = Date(),
                     completion: ((Bool, Error?) -> Void)? = nil) {
        guard let qtyType = HKQuantityType.quantityType(
                forIdentifier: .bodyTemperature
        ) else {
            completion?(false, nil)
            return
        }

        // A dummy quantity; real value lives in metadata
        let zeroQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: 0)

        // Metadata: LOINC + custom allele key
        let metadata: [String: Any] = [
            "com.nmdpMatchMeSwiftUI.nmdpMatchMeSwiftUI.loincCode": loincCode,
            "com.nmdpMatchMeSwiftUI.nmdpMatchMeSwiftUI.hlaAllele": allele
        ]


        let sample = HKQuantitySample(
            type: qtyType,
            quantity: zeroQuantity,
            start: date,
            end: date,
            metadata: metadata
        )

        healthStore.save(sample) { success, error in
            DispatchQueue.main.async {
                completion?(success, error)
            }
        }
    }

    /// Fetch the most recent HLA samples you’ve saved.
    func fetchRecentHLASamples(limit: Int = 50,
                               completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let qtyType = HKQuantityType.quantityType(
                forIdentifier: .bodyTemperature
        ) else {
            completion(nil, nil)
            return
        }

        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: qtyType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortByDate]
        ) { _, results, error in
            DispatchQueue.main.async {
                completion(results as? [HKQuantitySample], error)
            }
        }
        healthStore.execute(query)
    }
}
