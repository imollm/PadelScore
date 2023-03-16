//
//  ContentView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//

import SwiftUI

struct ScoreView: View {
    var body: some View {
        VStack {
            TeamAView()
            Divider()
              .frame(height: 2)
              .padding(.horizontal, 10)
            TeamBView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
            .environmentObject(MatchModel())
    }
}
