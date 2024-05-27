//
//  Home.swift
//  SafEar Watch App
//
//  Created by Anggara Satya Wimala Nelwan on 27/05/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack{
            Spacer()
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                Circle()
                    .foregroundColor(.blueAccent)
                    .frame(width: 150, height: 150)
                Circle()
                    .foregroundColor(.blueAccent)
                    .frame(width: 172, height: 172)
                    .opacity(0.8)
                Image(systemName: "ear.badge.waveform")
                    .resizable()
                    .fontWeight(.black)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 46, height: 46)
                    .padding(.bottom, 40)
                Text("Start")
                    .font(.system(size: 46, weight: .black, design: .default))
                    .padding(.top, 40)
            }
            .frame(width: .infinity, height: .infinity)
            .onTapGesture {
                router.navigate(destination: .stopwatch)
            }
            Spacer()
        }
    }
}

#Preview {
    Home()
}
