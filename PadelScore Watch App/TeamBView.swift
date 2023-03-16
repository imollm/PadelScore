//
//  TeamBView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct TeamBView: View {
    @EnvironmentObject var matchModel:MatchModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(matchModel.match.teamB.getSets()) { item in
                    Text(String(item.getPoints()))
                        .padding(.horizontal)
                }
            }
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
