//
//  PadelScore_Watch_AppTests.swift
//  PadelScore Watch AppTests
//
//  Created by Ivan Moll on 16/3/23.
//

// ------------------ //
// ------------------ //
// Possible Scenarios //
// ------------------ //
// ------------------ //

// 1. Has won the match [hasScoredTeamWonTheMatch]
// Team A -> [6] [6] [X]
// Team B -> [4] [2] [X]

// 2. Is there tie break
// Team A -> [5] [X] [X] -> [6] [X] [X]
// Team B -> [6] [X] [X] -> [6] [X] [X]

// 3. Increase with on game current set and start another one
// [hasCurrentSetBeenWonByScoredTeam]
// Team A -> [5] [X] [X] -> [6] [0] [X]
// Team B -> [0] [X] [X] -> [0] [0] [X]

// 4. Increase with one game the current set [hasCurrentGameBeenWonByScoredTeam]
// Team A -> [4] [X] [X] -> [5] [X] [X]
// Team B -> [1] [X] [X] -> [1] [X] [X]

// 5. Increase current points [addPoint]
// Team A ( 30 ) -> ( 40 )
// Team B (  0 ) -> (  0 )

import XCTest
@testable import PadelScore_Watch_App

class PadelScore_Watch_AppTests: XCTestCase {
    var match: Match!
    var teamA: Team!
    var teamB: Team!
    
    override func setUp() {
        super.setUp()
        match = Match()
        teamA = match.teamA
        teamB = match.teamB
    }
    
    override func tearDown() {
        match = nil
        teamA = nil
        teamB = nil
        super.tearDown()
    }
    
    func testAddPoint() {
        match.addPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentPoints(), FIFTY_POINTS)
    }
    
    func testAddTieBreakPoint() {
        match.isTieBreak = true
        match.addTieBreakPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "1")
    }
    
    func testSubtractPoint() {
        testAddPoint()
        teamA.substractPoint()
        XCTAssertEqual(teamA.getCurrentPoints(), ZERO_POINTS)
    }
    
    func testSubstractTieBreakPoint() {
        match.isTieBreak = true
        match.addTieBreakPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "1")
        teamA.substractTieBreakPoint()
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
    }
    
    func testResetPoints() {
        match.addPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentPoints(), FIFTY_POINTS)
        match.addPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentPoints(), THIRTY_POINTS)
        teamA.points.resetPoints()
        XCTAssertEqual(teamA.getCurrentPoints(), ZERO_POINTS)
    }
    
    func testResetTieBreakPoints() {
        match.isTieBreak = true
        match.addTieBreakPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "1")
        match.addTieBreakPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "2")
        teamA.tieBreakPoints.resetPoints()
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
    }
    
    func testAddSetGame() {
        teamA.addSetGame(setIndex: match.getCurrentSet())
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 1)
    }
    
    func testSubtractSetGame() {
        testAddSetGame()
        let setGames = teamA.getSet(setIndex: match.getCurrentSet()).getGames()
        teamA.substractSetGame(setIndex: match.getCurrentSet())
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), setGames - 1)
    }
    
    func testTeamWonFirstSet() {
        for _ in 1...5 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
        }
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 5)

        // Init points of teams
        for i in 1...3 {
            if (i <= 3) {
                let _ = teamA.addPoint() // 40 points
            }
            if (i < 3) {
                let _ = teamB.addPoint() // 30 points
            }
        }

        XCTAssertEqual(match.getCurrentSet(), 0)
        match.addPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentPoints(), ZERO_POINTS)
        XCTAssertEqual(match.getCurrentSet(), 1)

        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 0)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 0)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 0)
    }

    func testTeamWonSecondSetAndTheMatch() {
        // Win first set 6 - 0
        for _ in 1...6 {
            teamA.addSetGame(setIndex: 0)
        }
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Set second set of team A to 5 games
        match.currentSet = 1
        XCTAssertEqual(match.getCurrentSet(), 1)
        for _ in 1...5 {
            teamA.addSetGame(setIndex: 1)
        }
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        // Set points to 40
        for i in 1...3 {
            if (i <= 3) {
                let _ = teamA.addPoint() // 40 points
            }
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")

        match.addPoint(team: TEAM_A)
        
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 0)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 0)
        
        XCTAssertEqual(match.hasFinished, true)
        XCTAssertEqual(match.winner?.getName(), teamA.getName())
        XCTAssertEqual(teamA.getWinningSetsCount(), 2)
        XCTAssertEqual(teamB.getWinningSetsCount(), 0)
    }
    
    func testTeamWonSetGameAndMatchActiveModeTieBreak() {
        // Sets       1   2   3  | Points
        // Team A -> [5] [0] [0] | ( 40 )
        // Team B -> [6] [0] [0] | (  0 )
        for i in 1...6 {
            if (i < 6) {
                teamA.addSetGame(setIndex: 0)
            }
            if (i < 4) {
                teamA.points.addPoint()
            }
            teamB.addSetGame(setIndex: 0)
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: 0).getGames(), 5)
        XCTAssertEqual(teamB.getSet(setIndex: 0).getGames(), 6)
        
        match.addPoint(team: TEAM_A)
        
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
    }
    
    func testTeamWonFirstSetOfTheMatchByTieBreak() {
        // Sets       1   2   3  | Points
        // Team A -> [5] [0] [0] | ( 40 )
        // Team B -> [6] [0] [0] | (  0 )
        for i in 1...6 {
            if (i < 6) {
                teamA.addSetGame(setIndex: 0)
            }
            if (i < 4) {
                teamA.points.addPoint()
            }
            teamB.addSetGame(setIndex: 0)
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: 0).getGames(), 5)
        XCTAssertEqual(teamB.getSet(setIndex: 0).getGames(), 6)
        
        match.addPoint(team: TEAM_A)
        
        // Sets       1   2   3  | Points
        // Team A -> [6] [0] [0] | ( 0 )
        // Team B -> [6] [0] [0] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: 0).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: 0).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [0] [0] | ( 0 )
        // Team B -> [6] [0] [0] | ( 0 )
        match.addTieBreakPoint(team: TEAM_A)
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 1)
    }
}

