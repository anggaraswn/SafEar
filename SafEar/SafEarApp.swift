//
//  SafEarApp.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 15/05/24.
//

import SwiftUI

@main
struct SafEarApp: App {
    @StateObject var healthManager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
        }
    }
}
