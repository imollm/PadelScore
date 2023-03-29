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
let MATCH_WITH_ADVANTAGES: Int = 0
let MATCH_WITH_GOLDEN_POINT: Int = 1
let ZERO_POINTS: String = "0"
let FIFTY_POINTS: String = "15"
let THIRTY_POINTS: String = "30"
let FORTY_POINTS: String = "40"
let ADVANTAGE_POINT: String = "Ad"

internal class Point: PointProtocol {
    var points: Int
    var mappedPoints: Array<String>
    
    required init() {
        self.points = 0
        self.mappedPoints = [
            ZERO_POINTS,
            FIFTY_POINTS,
            THIRTY_POINTS,
            FORTY_POINTS
        ]
    }
    
    func resetPoints() -> Void {
        self.points = 0
    }
    
    func getPoints() -> String {
        return self.mappedPoints[self.points]
    }
    
    func getTieBreakPoints() -> String {
        return String(self.points)
    }
    
    func addPoint() -> Void {
        // TODO: Manage when the user requires play with advantages
        if (self.points < 3) {
            self.points += 1
        } else {
            self.resetPoints()
        }
    }
    
    func addTieBreakPoint() -> Void {
        self.points += 1
    }
    
    func substractPoint() -> Void {
        if (self.points > 0) {
            self.points -= 1
        }
    }
}

internal class Set: Identifiable, SetProtocol {
    var games: Int
    
    required init() {
        self.games = 0
    }
    
    func getGames() -> Int {
        return self.games
    }
    
    func addSetGame() -> Void {
        if (self.games < 7) {
            self.games += 1
        }
    }
    
    func substractSetGame() -> Void {
        if (self.games > 0) {
            self.games -= 1
        }
    }
}

internal class Team: TeamProtocol {
    var name: String
    var sets: [Set]
    var points: Point
    var tieBreakPoints: Point
    
    required init(name: String) {
        self.name = name
        self.sets = [Set(), Set(), Set()]
        self.points = Point()
        self.tieBreakPoints = Point()
    }
    
    func getSets() -> [Set] {
        return self.sets
    }
    
    func getSet(setIndex: Int) -> Set {
        return self.sets[setIndex]
    }
    
    func getName() -> String {
        return self.name
    }
    
    internal func addSetGame(setIndex: Int) -> Void {
        self.sets[setIndex].addSetGame()
    }
    
    func substractSetGame(setIndex: Int) -> Void {
        self.sets[setIndex].substractSetGame()
    }
    
    func getCurrentPoints() -> String {
        return self.points.getPoints()
    }
    
    func getCurrentTieBreakPoints() -> String {
        return self.tieBreakPoints.getTieBreakPoints()
    }
    
    func addPoint() -> Void {
        return self.points.addPoint()
    }
    
    func addTieBreakPoint() -> Void {
        return self.tieBreakPoints.addTieBreakPoint()
    }
    
    func substractPoint() -> Void {
        return self.points.substractPoint()
    }
    
    func substractTieBreakPoint() -> Void {
        return self.tieBreakPoints.substractPoint()
    }
    
    func getWinningSetsCount() -> Int {
        let count = self.sets.filter { item in item.getGames() >= 6 }.count
        return count
    }
}

public class Match: MatchProtocol {
    var teamA: Team
    var teamB: Team
    var currentSet: Int
    var hasFinished: Bool
    var isTieBreak: Bool
    var winner: Team?
    
    required init() {
        self.teamA = Team(name: TEAM_A)
        self.teamB = Team(name: TEAM_B)
        self.currentSet = 0
        self.hasFinished = false
        self.isTieBreak = false
        self.winner = nil
    }
    
    func getCurrentSet() -> Int {
        return self.currentSet
    }
    
    func nextSet() -> Void {
        if (self.currentSet < 2) {
            self.currentSet += 1
        }
    }
    
    func addSetPoint(team: String) -> Void {
        let incomingTeam = self.getTeamByName(team: team)
        incomingTeam.addSetGame(setIndex: self.currentSet)
    }
    
    func substractSetPoint(team: String) -> Void {
        let incomingTeam = self.getTeamByName(team: team)
        incomingTeam.substractSetGame(setIndex: self.currentSet)
    }
    
    func addPoint(team: String) -> Void {
        let teamThatHasScored = self.getTeamByName(team: team)
        
        if (self.hasScoredTeamWonTheMatch(teamThatHasScored: teamThatHasScored)) {
            self.hasFinished = true
            self.winner = teamThatHasScored
            self.teamA.points.resetPoints()
            self.teamB.points.resetPoints()
            teamThatHasScored.addSetGame(setIndex: self.getCurrentSet())
        } else if (self.hasTieBreak(teamThatHasScored: teamThatHasScored) && !self.isTieBreak) {
            self.isTieBreak = true
            self.teamA.points.resetPoints()
            self.teamB.points.resetPoints()
            teamThatHasScored.getSet(setIndex: self.getCurrentSet()).addSetGame()
        } else if (self.hasCurrentSetBeenWonByScoredTeam(teamThatHasScored: teamThatHasScored)) {
            self.teamA.points.resetPoints()
            self.teamB.points.resetPoints()
            teamThatHasScored.addSetGame(setIndex: self.getCurrentSet())
            self.nextSet()
        } else if (self.hasCurrentGameBeenWonByScoredTeam(teamThatHasScored: teamThatHasScored)) {
            self.teamA.points.resetPoints()
            self.teamB.points.resetPoints()
        } else {
             teamThatHasScored.addPoint()
        }
    }
    
    
    /// The winner will be the one who reaches 7 points, and if they tie at 6 points, the winner will be the one who achieves a 2-point difference.
    /// - Parameter team: The team that has scored tie break point
    /// - Returns: Void
    func addTieBreakPoint(team: String) -> Void {
        if (self.isTieBreak) {
            let teamThatHasScored = self.getTeamByName(team: team)
            let teamThatHasScoredTieBreakPoints = Int(teamThatHasScored.getCurrentTieBreakPoints())!
            let opponentTieBreakPoints = Int(self.getOpponent(team: teamThatHasScored).getCurrentTieBreakPoints())!
            let is2PointDifference = ((teamThatHasScoredTieBreakPoints + 1) - opponentTieBreakPoints) == 2
            
            if (
                (teamThatHasScoredTieBreakPoints == 6 && opponentTieBreakPoints < 6) ||
                (teamThatHasScoredTieBreakPoints >= 6 && opponentTieBreakPoints >= 6 && is2PointDifference)
            ) {
                if (self.hasScoredTeamWonTheMatch(teamThatHasScored: teamThatHasScored)) {
                    self.hasFinished = true
                    self.winner = teamThatHasScored
                    self.isTieBreak = false
                    teamThatHasScored.addSetGame(setIndex: self.getCurrentSet())
                    teamThatHasScored.tieBreakPoints.resetPoints()
                    self.getOpponent(team: teamThatHasScored).tieBreakPoints.resetPoints()
                    self.nextSet()
                } else {
                    teamThatHasScored.getSet(setIndex: self.getCurrentSet()).addSetGame()
                    teamThatHasScored.tieBreakPoints.resetPoints()
                    self.getOpponent(team: teamThatHasScored).tieBreakPoints.resetPoints()
                    self.isTieBreak = false
                    self.nextSet()
                }
            } else {
                teamThatHasScored.addTieBreakPoint()
            }
        }
    }
    
    func substractPoint(team: String) -> Void {
        let incomingTeam = self.getTeamByName(team: team)
        incomingTeam.substractPoint()
    }
    
    func substractTieBreakPoint(team: String) -> Void {
        let incomingTeam = self.getTeamByName(team: team)
        incomingTeam.substractTieBreakPoint()
    }
    
    func getTeamByName(team: String) -> Team {
        return team == TEAM_A ? self.teamA : self.teamB
    }
    
    func hasScoredTeamWonTheMatch(teamThatHasScored: Team) -> Bool {
        let opponent = self.getOpponent(team: teamThatHasScored)
        var hasWonTheMatch = false
        
        if (self.isTieBreak) {
            if (
                teamThatHasScored.getWinningSetsCount() == 1 &&
                opponent.getWinningSetsCount() < 2
            ) {
                hasWonTheMatch = true
            }
        } else {
            if (
                teamThatHasScored.getWinningSetsCount() == 1 &&
                teamThatHasScored.getSets()[self.getCurrentSet()].getGames() == 5 &&
                teamThatHasScored.getCurrentPoints() == FORTY_POINTS &&
                opponent.getWinningSetsCount() < 2
            ) {
                hasWonTheMatch = true
            }
        }
        
        return hasWonTheMatch
    }
    
    func hasTieBreak(teamThatHasScored: Team) -> Bool {
        var isTieBreak = false
        let currentSetGamesTeamHasScored = teamThatHasScored.getSet(setIndex: self.getCurrentSet()).getGames()
        let currentSetGamesOpponent = self.getOpponent(team: teamThatHasScored).getSet(setIndex: self.getCurrentSet()).getGames()
        
        if (
            currentSetGamesTeamHasScored == 5 &&
            currentSetGamesOpponent == 6 &&
            teamThatHasScored.getCurrentPoints() == FORTY_POINTS
        ) {
            isTieBreak = true
        }
        
        return isTieBreak
    }
    
    func hasCurrentSetBeenWonByScoredTeam(teamThatHasScored: Team) -> Bool {
        var hasBeenWonASetGame = false
        let teamScoredCurrentGames
            = teamThatHasScored.getSet(setIndex: self.getCurrentSet()).getGames()
        let opponentGamesOfCurrentSet
            = self.getOpponent(team: teamThatHasScored).getSet(setIndex: self.getCurrentSet()).getGames()
        let teamScoredCurrentPoints
            = teamThatHasScored.getCurrentPoints()
        
        if (
            teamScoredCurrentGames == 5 &&
            opponentGamesOfCurrentSet < 5 &&
            teamScoredCurrentPoints == FORTY_POINTS
        ) {
            hasBeenWonASetGame = true
        }
        
        return hasBeenWonASetGame
    }
    
    func hasCurrentGameBeenWonByScoredTeam(teamThatHasScored: Team) -> Bool {
        var hasBeenWonAGame = false
        
        if (teamThatHasScored.getCurrentPoints() == FORTY_POINTS) {
            teamThatHasScored.addSetGame(setIndex: self.currentSet)
            hasBeenWonAGame = true
        }
        
        return hasBeenWonAGame
    }
    
    func getOpponent(team: Team) -> Team {
        if (team.getName() == self.teamA.getName()) {
            return self.teamB
        } else {
            return self.teamA
        }
    }
}

public class MatchModel:ObservableObject {
    @Published var match:Match
    
    init() {
        self.match = Match()
    }
}
