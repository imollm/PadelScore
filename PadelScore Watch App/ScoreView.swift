//
//  ContentView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var matchModel:MatchModel
    @State var currentPointsTeamA: String = "0"
    @State var currentPointsTeamB: String = "0"
    @State var currentTieBreakPointsTeamA: String = "0"
    @State var currentTieBreakPointsTeamB: String = "0"
    
    var body: some View {
        VStack {
            TeamAView(
                currentPointsTeamA: $currentPointsTeamA,
                currentPointsTeamB: $currentPointsTeamB,
                currentTieBreakPointsTeamA: $currentTieBreakPointsTeamA,
                currentTieBreakPointsTeamB: $currentTieBreakPointsTeamB
            )
            Divider()
              .frame(height: 2)
              .padding(.horizontal, 10)
            TeamBView(
                currentPointsTeamA: $currentPointsTeamA,
                currentPointsTeamB: $currentPointsTeamB,
                currentTieBreakPointsTeamA: $currentTieBreakPointsTeamA,
                currentTieBreakPointsTeamB: $currentTieBreakPointsTeamB
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State var currentPointsTeamA: String = "0"
    @State var currentPointsTeamB: String = "0"
    @State var currentTieBreakPointsTeamA: String = "0"
    @State var currentTieBreakPointsTeamB: String = "0"
    
    static var previews: some View {
        ScoreView()
            .environmentObject(MatchModel())
    }
}
