//
//  WeeklyExposure.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//

import SwiftUI

struct WeeklyExposure: View {
    @ObservedObject var healthManager = HealthManager()
    
    
    var body: some View {
        VStack(spacing: 20){
            Text("Weekly Audio Exposure")
                .font(.system(size: 14, weight: .black, design: .default))
            ProgressSymbol(progress: healthManager.audioExposurePercentage / 100)
            Text("\(Int(healthManager.audioExposurePercentage))%")
                .font(.system(size: 20, weight: .black, design: .default))
        }
        .onAppear(perform: {
            healthManager.fetchWeeklyAudioExposure()
        })
    }
}

struct ProgressSymbol: View {
    var progress: Double

    var body: some View {
        ZStack {
            // Background icon
            Image(systemName: "ear")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            // Foreground icon masked by progress
            Image(systemName: "ear")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .mask(
                    Rectangle()
                        .size(width: 100, height: 100 * CGFloat(progress))
                        .offset(y: 100 * CGFloat(1 - progress))
                )
        }
    }
}

#Preview {
    WeeklyExposure()
}
