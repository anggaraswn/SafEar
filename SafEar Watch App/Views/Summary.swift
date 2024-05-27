//
//  Summary.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//

import SwiftUI

struct Summary: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel = StopwatchViewModel.shared
    
    var body: some View {
        VStack{
            VStack(spacing: 10){
                VStack(alignment: .leading){
                    Text("Time")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .bold, design: .default))
                    Text(timeString)
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 148)
                VStack(alignment: .leading){
                    Text("Average Decibel")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .bold, design: .default))
                    Text("\(Int(healthManager.averageDecibel)) dB")
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 148)
            }
            .padding(.trailing, 20)
            Button(action: {
                router.navigateToRoot()
            }, label: {
                Text("OK")
            })
            .frame(width: 172, height: 44)
            .buttonStyle(.borderedProminent)
            .tint(.blueAccent)
            .padding(.top, 10)
        }
        .frame(width: 220)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if let (startDate, endDate) = calculateStartAndEndDates() {
                healthManager.fetchAverageDecibel(from: startDate, to: endDate)
            }
        })
    }
    
    private var timeString: String {
        return "\(viewModel.hoursString):\(viewModel.minutesString):\(viewModel.secondsString)"
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
//
//#Preview {
//    Summary(time: "00:00:00")
//}
