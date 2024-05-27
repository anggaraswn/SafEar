//
//  ContentView.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 15/05/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    //    @StateObject private var audioMonitor = AudioMonitor()
    
    var body: some View {
        VStack {
            //            List(healthManager.headphoneAudioLevels, id: \.uuid) { sample in
            //                VStack(alignment: .leading) {
            //                    Text("Level: \(sample.quantity.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())) dB")
            //                    Text("Date: \(sample.startDate, formatter: healthManager.dateFormatter)")
            //                }
            //            }
            
            //            Text("Headphone Level")
            //                .font(.largeTitle)
            //            Text("\(audioMonitor.dBValue, specifier: "%.2f") dB")
            //                .font(.title)
            //                .padding()
            
//            Text("Average Decibel = \(Int(healthManager.averageDecibel)) dB")
            Text("\(Int(healthManager.audioExposurePercentage))%")
                .font(.system(size: 20, weight: .black, design: .default))
        }
        .padding()
        .onAppear {
            //            audioMonitor.startMonitoring()
            
            if let (startDate, endDate) = calculateStartAndEndDates(from: "00:10:00") {
                healthManager.fetchAverageDecibel(from: startDate, to: endDate)
                healthManager.fetchWeeklyAudioExposure()
            }
        }
        //        .onDisappear {
        //            audioMonitor.stopMonitoring()
        //        }
    }
    
    private func calculateStartAndEndDates(from time: String) -> (Date, Date)? {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 3 else { return nil }
        
        let hours = components[0]
        let minutes = components[1]
        let seconds = components[2]
        
        let now = Date()
        var dateComponents = DateComponents()
        dateComponents.hour = -hours
        dateComponents.minute = -minutes
        dateComponents.second = -seconds
        
        if let startDate = Calendar.current.date(byAdding: dateComponents, to: now) {
            return (startDate, now)
        }
        
        return nil
    }
}

//    #Preview {
//        ContentView()
//    }
