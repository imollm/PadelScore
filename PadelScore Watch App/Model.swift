//
//  Model.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 16/3/23.
//
// Match -> Teams -> Sets -> Points

import Foundation

let TEAM_A: String = "Team A"
let TEAM_B: String = "Team B"

class Point {
    var point: Int
    
    init() {
        self.point = 0
    }
    
    func resetScore() -> Void {
        self.point = 0
    }
    
    func getPoint() -> Int {
        return self.point
    }
    
    func addPoint() -> Int {
        if (self.point < 4) {
            self.point += 1
        }
        return self.getPoint()
    }
}

class Set:Identifiable {
    var points: Int
    
    init() {
        self.points = 0
    }
    
    func getPoints() -> Int {
        return self.points
    }
    
    func setPoints(points: Int) -> Void {
        self.points = points
    }
}

class Team {
    var name:String
    var sets:[Set]
    
    init(name: String) {
        self.name = name
        self.sets = [Set(), Set(), Set()]
    }
    
    func getSets() -> [Set] {
        return self.sets
    }
    
    func getSet(index: Int) -> Set {
        return self.sets[index]
    }
    
    func getName() -> String {
        return self.name
    }
}

class Match {
    var teamA:Team
    var teamB:Team
    var currentSet: Int
    
    init() {
        self.teamA = Team(name: TEAM_A)
        self.teamB = Team(name: TEAM_B)
        self.currentSet = 0
    }
    
    func getTeam(name: String) -> Team {
        if (name == "My Team") {
            return self.teamA
            
        } else {
            return self.teamB
            
        }
    }
    
    func getCurrentSet() -> Int {
        return self.currentSet + 1
    }
    
    func nextSet() -> Void {
        if (self.currentSet < 2) {
            self.currentSet += 1
        }
    }
    
    func addPoint(team: String) -> Void {
        switch(team) {
        case TEAM_A:
            let currentPoints = self.teamA.sets[self.currentSet].getPoints()
            self.teamA.sets[self.currentSet].setPoints(points: currentPoints + 1)
            break
        case TEAM_B:
            let currentPoints = self.teamB.sets[self.currentSet].getPoints()
            self.teamB.sets[self.currentSet].setPoints(points: currentPoints + 1)
            break
        default:
            break
        }
    }
    
    func substractPoint(team: String) -> Void {
        
    }
}

class MatchModel:ObservableObject {
    @Published var match:Match
    
    init() {
        self.match = Match()
    }
}
