//
//  MainView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 2/4/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var matchModel:MatchModel
    @State var isTieBreak: Bool = false
    @State var hasFinished: Bool = false
    
    var body: some View {
        if (self.hasFinished) {
            FinalResultView(
                hasFinished: $hasFinished
            )
        } else {
            ScoreView(
                isTieBreak: $isTieBreak,
                hasFinished: $hasFinished
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State var isTieBreak: Bool = false
    @State var hasFinished: Bool = false
    
    static var previews: some View {
        MainView()
            .environmentObject(MatchModel())
    }
}
