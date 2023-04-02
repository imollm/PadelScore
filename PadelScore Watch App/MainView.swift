//
//  MainView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 2/4/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var matchModel: MatchModel
    @State var hasStarted: Bool = false
    @State var isTieBreak: Bool = false
    @State var hasFinished: Bool = false
    @State var isGoldenPoint: Bool = false
    @State var isSuperTieBreak: Bool = false
    
    var body: some View {
        if (self.hasStarted) {
            if (self.hasFinished) {
                FinalResultView(
                    hasFinished: $hasFinished,
                    hasStarted: $hasStarted
                )
            } else {
                ScoreView(
                    isTieBreak: $isTieBreak,
                    hasFinished: $hasFinished
                )
            }
        } else {
            ConfigView(
                isGoldenPoint: $isGoldenPoint,
                isSuperTieBreak: $isSuperTieBreak,
                hasStarted: $hasStarted
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
