//
//  ConfigView.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 2/4/23.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var matchModel:MatchModel
    @Binding var isGoldenPoint: Bool
    @Binding var isSuperTieBreak: Bool
    @Binding var hasStarted: Bool
    
    var body: some View {
        VStack {
            Text("Choose your match config").font(.headline)
            Toggle(isOn: self.$isGoldenPoint) {
                Text("Golden point?")
            }.padding(.bottom).padding()
            Toggle(isOn: self.$isSuperTieBreak) {
                Text("Super tie break?")
            }.padding()
            Button("Ready") {
                self.hasStarted = true
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let isGoldenPoint = Binding<Bool>(get: { false }, set: { _ in })
        let isSuperTieBreak = Binding<Bool>(get: { false }, set: { _ in })
        let hasStarted = Binding<Bool>(get: { false }, set: { _ in })
        
        ConfigView(
            isGoldenPoint: isGoldenPoint,
            isSuperTieBreak: isSuperTieBreak,
            hasStarted: hasStarted
        ).environmentObject(MatchModel())
    }
}
