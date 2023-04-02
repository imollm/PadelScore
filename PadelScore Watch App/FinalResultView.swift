//
//  FinalResultView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 26/3/23.
//

import SwiftUI

struct FinalResultView: View {
    @EnvironmentObject var matchModel:MatchModel
    @Binding var hasFinished: Bool
    @Binding var hasStarted: Bool
    
    var body: some View {
        VStack {
            Text((self.matchModel.match.winner?.getName() ?? "") + " has won").padding(.vertical)
            
            HStack {
                ForEach(self.matchModel.match.teamA.getSets()) { item in
                    Text(String(item.getGames()))
                        .padding(.horizontal)
                }
            }
            
            Divider().frame(height: 2).padding(.horizontal, 10)
            
            HStack {
                ForEach(self.matchModel.match.teamB.getSets()) { item in
                    Text(String(item.getGames()))
                        .padding(.horizontal)
                }
            }
            Button("Reset match") {
                self.hasFinished = false
                self.hasStarted = false
                self.matchModel.match.resetMatch()
            }.padding(.top)
        }
    }
}

struct FinalResultView_Previews: PreviewProvider {
    static var previews: some View {
        let hasFinished = Binding<Bool>(get: { false }, set: { _ in })
        let hasStarted = Binding<Bool>(get: { false }, set: { _ in })
        
        FinalResultView(
            hasFinished: hasFinished,
            hasStarted: hasStarted
        ).environmentObject(MatchModel())
    }
}
