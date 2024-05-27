//
//  Router.swift
//  SafEar
//
//  Created by Anggara Satya Wimala Nelwan on 26/05/24.
//

import Foundation
import SwiftUI


class Router: ObservableObject{
    @Published var navPath = NavigationPath()
    
    enum Destination: Hashable{
        case stopwatch
        case summary
        case warning
        case weeklyExposure
    }
    
    func navigate(destination: Destination){
        navPath.append(destination)
    }
    
    func navigateBack(){
        navPath.removeLast()
    }
    
    func navigateToRoot(){
        navPath.removeLast(navPath.count)
    }
}
