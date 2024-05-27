//
//  StopWatch.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//

import SwiftUI

struct StopWatch: View {
    @EnvironmentObject var router: Router
    @State private var countdown:Int? = nil
    @ObservedObject var viewModel = StopwatchViewModel.shared
    
    var body: some View {
        VStack{
            if let countdown = countdown {
                Spacer()
                Text("\(countdown)")
                    .font(.system(size: 140, weight: .bold, design: .default))
                Spacer()
            }else{
                VStack{
                    ProgressBarView(progress: $viewModel.secondsElapsed, goal: .constant(60), seconds: $viewModel.secondsString)
                    
                    HStack(alignment: .bottom, spacing: 1){
                        Text(viewModel.hoursString)
                            .foregroundColor(.blueAccent)
                            .font(.system(size: 40, weight: .semibold, design: .default))
                        Text("h")
                            .foregroundColor(.gray)
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .padding(.bottom, 5)
                        Text(" : ")
                            .foregroundColor(.gray)
                            .font(.system(size: 40, weight: .semibold, design: .default))
                        Text(viewModel.minutesString)
                            .foregroundColor(.blueAccent)
                            .font(.system(size: 40, weight: .semibold, design: .default))
                        Text("m")
                            .foregroundColor(.gray)
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .padding(.bottom, 5)
                    }
                }
                .onAppear(perform: {
                    viewModel.start()
                })
                .padding(.top, 20)
                Spacer()
                Image(systemName: "stop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary, .red)
                    .onTapGesture {
                        viewModel.stop()
                        let formattedTime = String(format: "%02d:%02d:%02d", Int(viewModel.hoursString) ?? 0, Int(viewModel.minutesString) ?? 0, Int(viewModel.secondsString) ?? 0)
                        router.navigate(destination: .summary)
                    }
            }
        }
        .onAppear(perform: {
            self.countdown = 3
            startCountdown()
        })
        .sheet(isPresented: $viewModel.showAlert, content: {
            Warning()
        })
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    private func startCountdown(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let countdown = countdown, countdown > 0 {
                self.countdown = countdown - 1
            } else{
                self.countdown = nil
            }
        }
    }
}

#Preview {
    StopWatch()
}
