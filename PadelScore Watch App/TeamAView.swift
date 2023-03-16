//
//  TeamAView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct TeamAView: View {
    @EnvironmentObject var matchModel:MatchModel
    
    var body: some View {
        VStack {
            Text(matchModel.match.teamA.getName()).fontWeight(.bold)
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                })
                .frame(width: 50.0, height: 100.0)
                
                Text("15").font(.title2).padding(.horizontal, 20.0)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "minus")
                })
                .frame(width: 50.0, height: 100.0)
            }
            .padding(.vertical, -20)
            HStack {
                ForEach(matchModel.match.teamA.getSets()) { item in
                    Text(String(item.getPoints()))
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct TeamAView_Previews: PreviewProvider {
    static var previews: some View {
        TeamAView()
            .environmentObject(MatchModel())
    }
}
