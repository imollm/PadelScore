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
    @State var isTieBreak: Bool = false
    @State var hasFinished: Bool = false
    
    var body: some View {
        if (self.hasFinished) {
            FinalResultView()
        } else {
            VStack {
                TeamAView(
                    currentPointsTeamA: $currentPointsTeamA,
                    currentPointsTeamB: $currentPointsTeamB,
                    currentTieBreakPointsTeamA: $currentTieBreakPointsTeamA,
                    currentTieBreakPointsTeamB: $currentTieBreakPointsTeamB,
                    isTieBreak: $isTieBreak,
                    hasFinished: $hasFinished
                )
                if (isTieBreak) {
                    Text("TIE BREAK")
                } else {
                    Divider().frame(height: 2).padding(.horizontal, 10)
                }
                TeamBView(
                    currentPointsTeamA: $currentPointsTeamA,
                    currentPointsTeamB: $currentPointsTeamB,
                    currentTieBreakPointsTeamA: $currentTieBreakPointsTeamA,
                    currentTieBreakPointsTeamB: $currentTieBreakPointsTeamB,
                    isTieBreak: $isTieBreak,
                    hasFinished: $hasFinished
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State var currentPointsTeamA: String = "0"
    @State var currentPointsTeamB: String = "0"
    @State var currentTieBreakPointsTeamA: String = "0"
    @State var currentTieBreakPointsTeamB: String = "0"
    @State var isTieBreak: Bool = false
    @State var hasFinished: Bool = false
    
    static var previews: some View {
        ScoreView()
            .environmentObject(MatchModel())
    }
}
