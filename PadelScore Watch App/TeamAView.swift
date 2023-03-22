//
//  TeamAView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct TeamAView: View {
    @EnvironmentObject var matchModel:MatchModel
    @Binding var currentPointsTeamA: String
    @Binding var currentPointsTeamB: String
    @Binding var currentTieBreakPointsTeamA: String
    @Binding var currentTieBreakPointsTeamB: String
    
    var body: some View {
        VStack {
            Text(self.matchModel.match.teamA.getName()).fontWeight(.bold)
            HStack {
                Button(action: {
                    if (self.matchModel.match.isTieBreak) {
                        self.matchModel.match.addTieBreakPoint(team: TEAM_A)
                        self.currentTieBreakPointsTeamA = self.matchModel.match.teamA.getCurrentTieBreakPoints()
                        self.currentTieBreakPointsTeamB =
                            self.matchModel.match.teamB.getCurrentTieBreakPoints()
                        
                    } else {
                        self.matchModel.match.addPoint(team: TEAM_A)
                        self.currentPointsTeamA = self.matchModel.match.teamA.getCurrentPoints()
                        self.currentPointsTeamB =
                            self.matchModel.match.teamB.getCurrentPoints()
                    }
                }, label: {
                    Image(systemName: "plus")
                })
                .frame(width: 50.0, height: 100.0)
                
                Text(self.matchModel.match.isTieBreak ? "\(self.currentTieBreakPointsTeamA)" : "\(self.currentPointsTeamA)")
                    .font(.title2)
                    .padding(.horizontal, 20.0)
                
                Button(action: {
                    if (self.matchModel.match.isTieBreak) {
                        self.matchModel.match.substractTieBreakPoint(team: TEAM_A)
                        self.currentTieBreakPointsTeamA = self.matchModel.match.teamA.getCurrentTieBreakPoints()
                    } else {
                        self.matchModel.match.substractPoint(team: TEAM_A)
                        self.currentPointsTeamA = self.matchModel.match.teamA.getCurrentPoints()
                        self.currentPointsTeamB =
                            self.matchModel.match.teamB.getCurrentPoints()
                    }
                }, label: {
                    Image(systemName: "minus")
                })
                .frame(width: 50.0, height: 100.0)
            }
            .padding(.vertical, -20)
            
            if (!self.matchModel.match.isTieBreak) {
                HStack {
                    ForEach(matchModel.match.teamA.getSets()) { item in
                        Text(String(item.getGames()))
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct TeamAView_Previews: PreviewProvider {
    static var previews: some View {
        let currentPointsTeamA = Binding<String>(get: { "0" }, set: { _ in })
        let currentPointsTeamB = Binding<String>(get: { "0" }, set: { _ in })
        let currentTieBreakPointsTeamA = Binding<String>(get: { "0" }, set: { _ in })
        let currentTieBreakPointsTeamB = Binding<String>(get: { "0" }, set: { _ in })
        
        TeamAView(
            currentPointsTeamA: currentPointsTeamA,
            currentPointsTeamB: currentPointsTeamB,
            currentTieBreakPointsTeamA: currentTieBreakPointsTeamA,
            currentTieBreakPointsTeamB: currentTieBreakPointsTeamB)
            .environmentObject(MatchModel())
    }
}
