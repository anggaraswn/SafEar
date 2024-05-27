//
//  SafEarApp.swift
//  SafEar Watch App
//
//  Created by Anggara Satya Wimala Nelwan on 15/05/24.
//

import SwiftUI

@main
struct SafEar_Watch_AppApp: App {
    @StateObject var router = Router()
    @StateObject var healthManager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath){
                ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination{
                        case .stopwatch:
                            StopWatch()
                        case .summary:
                            Summary()
                        case .warning:
                            Warning()
                        case .weeklyExposure:
                            WeeklyExposure()
                        }
                    
                    }
            }
            .environmentObject(router)
            .environmentObject(healthManager)
        }
    }
}
