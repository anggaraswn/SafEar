//
//  ProgressBarView.swift
//  SafEar Watch App
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//
import SwiftUI

struct ProgressBarView: View {
    @Binding var progress: TimeInterval
    @Binding var goal: Double
    @Binding var seconds: String
    
    var body: some View {
        ZStack {
            defaultCircle
            progressCircle
            Text(seconds)
                .font(.system(size: 20, weight: .medium, design: .default))
        }
    }
    
    private var defaultCircle: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .butt, dash: [1, (2 * .pi * 35) / 60 - 1]))
            .foregroundColor(Color.gray.opacity(0.3))
            .rotationEffect(Angle(degrees: -90))
            .frame(width: 60, height: 60)
    }
    
    private var progressCircle: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(progress) / CGFloat(goal))
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .butt, dash: [1, (2 * .pi * 35) / 60 - 1]))
            .animation(.linear(duration: 1.0), value: progress)
            .rotationEffect(Angle(degrees: -90))
            .frame(width: 60, height: 60)
    }
}

#Preview {
    ProgressBarView(progress: .constant(30), goal: .constant(60), seconds: .constant("30"))
}
