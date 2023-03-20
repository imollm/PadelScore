//
//  TeamBView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct TeamBView: View {
    @EnvironmentObject var matchModel:MatchModel
    @State var currentPoints: String = "0"
    
    var body: some View {
        VStack {
            HStack {
                ForEach(matchModel.match.teamB.getSets()) { item in
                    Text(String(item.getGames()))
                        .padding(.horizontal)
                }
            }
            HStack {
                Button(action: {
                    self.matchModel.match.addPoint(team: TEAM_B)
                    self.currentPoints = self.matchModel.match.teamB.getCurrentPoints()
                }, label: {
                    Image(systemName: "plus")
                })
                .frame(width: 50.0, height: 100.0)
                
                Text("\(self.currentPoints)")
                    .font(.title2)
                    .padding(.horizontal, 20.0)
                
                Button(action: {
                    self.matchModel.match.substractPoint(team: TEAM_B)
                    self.currentPoints = self.matchModel.match.teamB.getCurrentPoints()
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
        TeamBView()
            .environmentObject(MatchModel())
    }
}
