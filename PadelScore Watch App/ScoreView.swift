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
    @Binding var isTieBreak: Bool
    @Binding var hasFinished: Bool
    
    var body: some View {
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

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        let isTieBreak = Binding<Bool>(get: { false }, set: { _ in })
        let hasFinished = Binding<Bool>(get: { false }, set: { _ in })

        ScoreView(
            isTieBreak: isTieBreak,
            hasFinished: hasFinished
        ).environmentObject(MatchModel())
    }
}
