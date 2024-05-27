//
//  HealthManager.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 16/05/24.
//import Foundation
import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    let healthTypes: Set = [HKQuantityType(.headphoneAudioExposure)]
    let dateFormatter: DateFormatter
    
    @Published var headphoneAudioLevels: [HKQuantitySample] = []
    @Published var averageDecibel: Double = 0.0
    @Published var audioExposurePercentage: Double = 0.0
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "id_ID") // Indonesian locale
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        
        Task(priority: .background) {
            do {
                if HKHealthStore.isHealthDataAvailable() {
                    try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                    startObservingHeadphoneAudioLevels()
                    enableBackgroundDelivery()
                }
            } catch {
                fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
            }
        }
    }
    
    func startObservingHeadphoneAudioLevels() {
        let headphoneAudioLevelType = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!
        let query = HKObserverQuery(sampleType: headphoneAudioLevelType, predicate: nil) { [weak self] query, completionHandler, error in
            if let error = error {
                print("Observer query error: \(error.localizedDescription)")
                return
            }
            self?.fetchHeadphoneAudioLevels { fetchError in
                if let fetchError = fetchError {
                    print("Error fetching headphone audio levels: \(fetchError)")
                }
                completionHandler()
            }
        }
        healthStore.execute(query)
    }
    
    func enableBackgroundDelivery() {
        let headphoneAudioLevelType = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!
        healthStore.enableBackgroundDelivery(for: headphoneAudioLevelType, frequency: .immediate) { success, error in
            if !success {
                print("Failed to enable background delivery: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func fetchHeadphoneAudioLevels(completion: @escaping (Error?) -> Void) {
        let headphoneAudioLevelType = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: headphoneAudioLevelType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples = samples as? [HKQuantitySample] else {
                completion(error)
                return
            }
            DispatchQueue.main.async {
                self.headphoneAudioLevels = samples
                for sample in samples {
                    let value = sample.quantity.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
                    let date = self.dateFormatter.string(from: sample.startDate)
                    print("Headphone audio level: \(value) dB at \(date)")
                }
                completion(nil)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchAverageDecibel(from startDate: Date, to endDate: Date) {
        let audioExposureType = HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: audioExposureType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
            if let error = error {
                print("Error fetching average decibel: \(error.localizedDescription)")
                return
            }
            
            if let result = result, let average = result.averageQuantity() {
                let averageValue = average.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
                DispatchQueue.main.async {
                    self.averageDecibel = averageValue
                    print("Average = \(averageValue)")
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchWeeklyAudioExposure() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let startOfWeek = calendar.date(byAdding: .day, value: -7, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfWeek, end: now, options: .strictStartDate)
        let sampleType = HKSampleType.quantityType(forIdentifier: .headphoneAudioExposure)!
        
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
            guard let result = result, let average = result.averageQuantity() else {
                print("Failed to fetch audio exposure: \(String(describing: error))")
                return
            }
            
            let exposureLimit: Double = 80
            let averageExposure = average.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
            
            DispatchQueue.main.async {
                print("Average Exposure = \(averageExposure)")
                self.audioExposurePercentage = (averageExposure / exposureLimit) * 100
            }
        }
        
        healthStore.execute(query)
    }
}
