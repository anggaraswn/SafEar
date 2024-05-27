//
//  ContentView.swift
//  SafEar Watch App
//
//  Created by Anggara Satya Wimala Nelwan on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
            WeeklyExposure()
        }
        .tabViewStyle(.verticalPage)
        .frame(width: 200, height: 200)
    }
}


#Preview {
    ContentView()
}
