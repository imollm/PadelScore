//
//  FinalResultView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 26/3/23.
//

import SwiftUI

struct FinalResultView: View {
    @EnvironmentObject var matchModel:MatchModel
    
    var body: some View {
        VStack {
            Text((self.matchModel.match.winner?.getName() ?? "") + " has won").padding(.vertical)
            
            VStack {
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
            }
        }
    }
}

struct FinalResultView_Previews: PreviewProvider {
    static var previews: some View {
        FinalResultView()
            .environmentObject(MatchModel())
    }
}
