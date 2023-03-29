//
//  TeamBView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct TeamBView: View {
    @EnvironmentObject var matchModel:MatchModel
    @Binding var currentPointsTeamA: String
    @Binding var currentPointsTeamB: String
    @Binding var currentTieBreakPointsTeamA: String
    @Binding var currentTieBreakPointsTeamB: String
    @Binding var isTieBreak: Bool
    @Binding var hasFinished: Bool
    
    var body: some View {
        VStack {
            if (!self.isTieBreak) {
                HStack {
                    ForEach(matchModel.match.teamB.getSets()) { item in
                        Text(String(item.getGames()))
                            .padding(.horizontal)
                    }
                }
            }
            HStack {
                Button(action: {
                    if (self.matchModel.match.isTieBreak) {
                        self.matchModel.match.addTieBreakPoint(team: TEAM_B)
                        self.currentTieBreakPointsTeamA = self.matchModel.match.teamA.getCurrentTieBreakPoints()
                        self.currentTieBreakPointsTeamB =
                            self.matchModel.match.teamB.getCurrentTieBreakPoints()
                        
                    } else {
                        self.matchModel.match.addPoint(team: TEAM_B)
                        self.currentPointsTeamA = self.matchModel.match.teamA.getCurrentPoints()
                        self.currentPointsTeamB =
                            self.matchModel.match.teamB.getCurrentPoints()
                    }
                    
                    self.isTieBreak = self.matchModel.match.isTieBreak
                    self.hasFinished = self.matchModel.match.hasFinished
                }, label: {
                    Image(systemName: "plus")
                })
                .frame(width: 50.0, height: 100.0)
                
                Text(self.matchModel.match.isTieBreak ? "\(self.currentTieBreakPointsTeamB)" : "\(self.currentPointsTeamB)")
                    .font(.title2)
                    .padding(.horizontal, 20.0)
                
                Button(action: {
                    if (self.matchModel.match.isTieBreak) {
                        self.matchModel.match.substractTieBreakPoint(team: TEAM_B)
                        self.currentTieBreakPointsTeamA = self.matchModel.match.teamA.getCurrentTieBreakPoints()
                    } else {
                        self.matchModel.match.substractPoint(team: TEAM_B)
                        self.currentPointsTeamA = self.matchModel.match.teamA.getCurrentPoints()
                        self.currentPointsTeamB =
                            self.matchModel.match.teamB.getCurrentPoints()
                    }
                    
                    self.isTieBreak = self.matchModel.match.isTieBreak
                    self.hasFinished = self.matchModel.match.hasFinished
                }, label: {
                    Image(systemName: "minus")
                })
                .frame(width: 50.0, height: 100.0)
            }.padding(.vertical, -20)
            
            Text(matchModel.match.teamB.getName()).fontWeight(.bold)
        }
    }
}

struct TeamBView_Previews: PreviewProvider {
    static var previews: some View {
        let currentPointsTeamA = Binding<String>(get: { "0" }, set: { _ in })
        let currentPointsTeamB = Binding<String>(get: { "0" }, set: { _ in })
        let currentTieBreakPointsTeamA = Binding<String>(get: { "0" }, set: { _ in })
        let currentTieBreakPointsTeamB = Binding<String>(get: { "0" }, set: { _ in })
        let isTieBreak = Binding<Bool>(get: { false }, set: { _ in })
        let hasFinished = Binding<Bool>(get: { false }, set: { _ in })
        
        TeamBView(
            currentPointsTeamA: currentPointsTeamA,
            currentPointsTeamB: currentPointsTeamB,
            currentTieBreakPointsTeamA: currentTieBreakPointsTeamA,
            currentTieBreakPointsTeamB: currentTieBreakPointsTeamB,
            isTieBreak: isTieBreak,
            hasFinished: hasFinished)
            .environmentObject(MatchModel())
    }
}
