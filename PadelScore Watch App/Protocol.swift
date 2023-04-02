//
//  Protocol.swift
//  PadelScore Watch App
//
//  Created by Ivan Moll on 17/3/23.
//

protocol PointProtocol {
    var points: Int { get set }
    var mappedPoints: Array<String> { get set }
    
    init()
    
    func resetPoints() -> Void
    func getPoints() -> String
    func getTieBreakPoints() -> String
    func addPoint() -> Void
    func addTieBreakPoint() -> Void
    func substractPoint() -> Void
}

protocol SetProtocol {
    var games: Int { get set }
    
    init()
    
    func getGames() -> Int
    func addSetGame() -> Void
    func substractSetGame() -> Void
}

protocol TeamProtocol {
    var name: String { get set }
    var sets: [Set] { get set }
    var points: Point { get set }
    var tieBreakPoints: Point { get set }
    var numSetsWon: Int { get set }
    
    init(name: String)
    
    func getSets() -> [Set]
    func getSet(setIndex: Int) -> Set
    func getName() -> String
    func addSetGame(setIndex: Int) -> Void
    func substractSetGame(setIndex: Int) -> Void
    func getCurrentPoints() -> String
    func getCurrentTieBreakPoints() -> String
    func addPoint() -> Void
    func addTieBreakPoint() -> Void
    func substractPoint() -> Void
    func substractTieBreakPoint() -> Void
    func addSetWon() -> Void
    func getSetsWon() -> Int
    func reset() -> Void
}


protocol MatchProtocol {
    var teamA: Team { get }
    var teamB: Team { get }
    var currentSet: Int { get }
    var hasFinished: Bool { get }
    var isTieBreak: Bool { get }
    var winner: Team? { get }
    
    init()
    
    func getCurrentSet() -> Int
    func nextSet() -> Void
    func addSetPoint(team: String)
    func substractSetPoint(team: String)
    func addPoint(team: String) -> Void
    func addTieBreakPoint(team: String) -> Void
    func substractPoint(team: String) -> Void
    func substractTieBreakPoint(team: String) -> Void
    func getTeamByName(team: String) -> Team
    func hasScoredTeamWonTheMatch(teamThatHasScored: Team) -> Bool
    func hasTieBreak(teamThatHasScored: Team) -> Bool
    func hasCurrentSetBeenWonByScoredTeam(teamThatHasScored: Team) -> Bool
    func hasCurrentGameBeenWonByScoredTeam(teamThatHasScored: Team) -> Bool
    func getOpponent(team: Team) -> Team
    func resetMatch() -> Void
}
