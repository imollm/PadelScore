//
//  PadelScoreApp.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

@main
struct PadelScore_Watch_AppApp: App {
    @StateObject var matchModel:MatchModel = MatchModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(matchModel)
        }
    }
}
