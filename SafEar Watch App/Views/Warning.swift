//
//  Warning.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//

import SwiftUI

struct Warning: View {
    @EnvironmentObject var healthManager: HealthManager
    @ObservedObject var viewModel = StopwatchViewModel.shared
    
    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.triangle.fill")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 59, height: 60)
            warningText
                .frame(width: 148)
                .font(.system(size: 13, weight: .regular, design: .default))
                .padding(.top, 10)
        }
        .onAppear(perform: {
            if let (startDate, endDate) = calculateStartAndEndDates() {
                healthManager.fetchAverageDecibel(from: startDate, to: endDate)
            }
        })
    }
    
    private var warningText: Text {
        let hours = Int(viewModel.hoursString) ?? 0
        let minutes = Int(viewModel.minutesString) ?? 0
        
        if hours > 0 {
            return Text("Headphone audio levels hit average **\(Int(healthManager.averageDecibel)) dB** for **\(hours) hour\(hours > 1 ? "s" : "") and \(minutes) minute\(minutes != 1 ? "s" : "")**")
        } else {
            return Text("Headphone audio levels hit average **\(Int(healthManager.averageDecibel)) dB** for **\(minutes) minute\(minutes != 1 ? "s" : "")**")
        }
    }
    
    private func calculateStartAndEndDates() -> (Date, Date)? {
        guard let hours = Int(viewModel.hoursString), let minutes = Int(viewModel.minutesString), let seconds = Int(viewModel.secondsString) else {
            return nil
        }
        
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

//#Preview {
//    Warning()
//}
