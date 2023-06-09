//
//  PadelScore_Watch_AppTests.swift
//  PadelScore Watch AppTests
//
//  Created by Ivan Moll on 16/3/23.
//

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
        // Set first set of team A to 5 games
        for _ in 1...5 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
        }
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 0)
        
        // Set points to 40
        for i in 1...3 {
            if (i <= 3) {
                let _ = teamA.addPoint() // 40 points
            }
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")
        
        // Win the set
        match.addPoint(team: TEAM_A)
        
        XCTAssertEqual(match.getCurrentSet(), 1)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 0)
        XCTAssertFalse(match.hasFinished)
        XCTAssertNil(match.winner?.getName(), teamA.getName())
        XCTAssertEqual(teamA.getSetsWon(), 1)
        XCTAssertEqual(teamB.getSetsWon(), 0)
        
        // Set second set of team A to 5 games
        for _ in 1...5 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
        }
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        // Set points to 40
        for i in 1...3 {
            if (i <= 3) {
                let _ = teamA.addPoint() // 40 points
            }
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")

        // Win second set and the match
        match.addPoint(team: TEAM_A)
        
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 0)
        
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 0)
        
        XCTAssertTrue(match.hasFinished)
        XCTAssertEqual(match.winner?.getName(), teamA.getName())
        XCTAssertEqual(teamA.getSetsWon(), 2)
        XCTAssertEqual(teamB.getSetsWon(), 0)
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
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [0] [0] | ( 6 )
        // Team B -> [6] [0] [0] | ( 0 )
        match.addTieBreakPoint(team: TEAM_A) // Adding the 7th point for Team A to win the set
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 1)
    }
    
    func testTeamWonFirstSetOfTheMatchByTieBreakByDiffOfTwo() {
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
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 6 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point
        
        // Still disputing first set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 7 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "7")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "6")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 8 )
        // Team B -> [6] [0] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point and win the set
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 1)
    }
    
    func testTeamAWinsTheMatchWith2TieBreaks() {
        //-----------------//
        // START FIRST SET //
        //-----------------//
        
        // Sets       1   2   3  | Points
        // Team A -> [6] [0] [0] | (  0 )
        // Team B -> [5] [0] [0] | ( 40 )
        for i in 1...6 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
            
            if (i < 6) {
                teamB.addSetGame(setIndex: match.getCurrentSet())
            }
            
            if (i < 4) {
                teamB.points.addPoint()
            }
        }
        XCTAssertEqual(teamB.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        match.addPoint(team: TEAM_B)
        
        // Sets       1   2   3  | Points
        // Team A -> [6] [0] [0] | ( 0 )
        // Team B -> [6] [0] [0] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 6 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point
        
        // Still disputing first set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 7 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "7")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "6")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 8 )
        // Team B -> [6] [0] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point and win the set
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 1)

        //------------------//
        // START SECOND SET //
        //------------------//
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [6] [0] | (  0 )
        // Team B -> [6] [5] [0] | ( 40 )
        for i in 1...6 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
            
            if (i < 6) {
                teamB.addSetGame(setIndex: match.getCurrentSet())
            }
            
            if (i < 4) {
                teamB.points.addPoint()
            }
        }
        XCTAssertEqual(teamB.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        match.addPoint(team: TEAM_B)
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [6] [0] | ( 0 )
        // Team B -> [6] [6] [0] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 1)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 6 )
        // Team B -> [6] [6] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point
        
        // Still disputing second set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 7 )
        // Team B -> [6] [6] [0] | ( 6 )
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "7")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "6")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 1)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 8 )
        // Team B -> [6] [6] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point and win the set and the match
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertTrue(match.hasFinished)
        XCTAssertEqual(match.winner?.getName(), teamA.getName())
    }
    
    func testTeamAWins2SetsAndTeamBWins1Set() {
        //-------------------------------------------------//
        // START FIRST SET WINNED BY TEAM A WITH TIE BREAK //
        //-------------------------------------------------//
        
        // Sets       1   2   3  | Points
        // Team A -> [6] [0] [0] | (  0 )
        // Team B -> [5] [0] [0] | ( 40 )
        for i in 1...6 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
            
            if (i < 6) {
                teamB.addSetGame(setIndex: match.getCurrentSet())
            }
            
            if (i < 4) {
                teamB.points.addPoint()
            }
        }
        XCTAssertEqual(teamB.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        match.addPoint(team: TEAM_B)
        
        // Sets       1   2   3  | Points
        // Team A -> [6] [0] [0] | ( 0 )
        // Team B -> [6] [0] [0] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 6 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point
        
        // Still disputing first set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 7 )
        // Team B -> [6] [0] [0] | ( 6 )
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "7")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "6")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 0)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [6] [0] [0] | ( 8 )
        // Team B -> [6] [0] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point and win the set
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 1)

        //------------------------------------------------//
        // START SECOND SET WINNED BY TEAM B BY TIE BREAK //
        //------------------------------------------------//
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [5] [0] | ( 40 )
        // Team B -> [6] [6] [0] | (  0 )
        for i in 1...6 {
            teamB.addSetGame(setIndex: match.getCurrentSet())
            
            if (i < 6) {
                teamA.addSetGame(setIndex: match.getCurrentSet())
            }
            
            if (i < 4) {
                teamA.points.addPoint()
            }
        }
        XCTAssertEqual(teamA.getCurrentPoints(), "40")
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        match.addPoint(team: TEAM_A)
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [6] [0] | ( 0 )
        // Team B -> [6] [6] [0] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 1)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 6 )
        // Team B -> [6] [6] [0] | ( 6 )
        match.addTieBreakPoint(team: TEAM_B) // Team B win a tie break point
        
        // Still disputing second set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 6 )
        // Team B -> [6] [6] [0] | ( 7 )
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "6")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "7")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 1)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [0] | ( 6 )
        // Team B -> [6] [6] [0] | ( 8 )
        match.addTieBreakPoint(team: TEAM_B) // Team B win a tie break point and win the set
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet() - 1).getGames(), 7)
        XCTAssertEqual(match.getCurrentSet(), 2)
        
        //-----------------------------------------------//
        // START THIRD SET WINNED BY TEAM A BY TIE BREAK //
        //-----------------------------------------------//
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [6] [6] | (  0 )
        // Team B -> [6] [7] [5] | ( 40 )
        for i in 1...6 {
            teamA.addSetGame(setIndex: match.getCurrentSet())
            
            if (i < 6) {
                teamB.addSetGame(setIndex: match.getCurrentSet())
            }
            
            if (i < 4) {
                teamB.points.addPoint()
            }
        }
        XCTAssertEqual(teamB.getCurrentPoints(), "40")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 5)
        
        match.addPoint(team: TEAM_B)
        
        // Sets       1   2   3  | Points
        // Team A -> [7] [6] [6] | ( 0 )
        // Team B -> [6] [7] [6] | ( 0 )
        XCTAssertEqual(match.getCurrentSet(), 2)
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(teamA.getCurrentPoints(), "0")
        XCTAssertEqual(teamB.getCurrentPoints(), "0")
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        for i in 1...6 {
            match.addTieBreakPoint(team: TEAM_A)
            XCTAssertEqual(teamA.getCurrentTieBreakPoints(), String(i))
            match.addTieBreakPoint(team: TEAM_B)
            XCTAssertEqual(teamB.getCurrentTieBreakPoints(), String(i))
        }
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [6] | ( 6 )
        // Team B -> [6] [7] [6] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point
        
        // Still disputing second set
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [6] | ( 7 )
        // Team B -> [6] [7] [6] | ( 6 )
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "7")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "6")
        XCTAssertTrue(match.isTieBreak)
        XCTAssertEqual(match.getCurrentSet(), 2)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        
        // Sets       1   2   3  | Tie Break Points
        // Team A -> [7] [6] [6] | ( 8 )
        // Team B -> [6] [7] [6] | ( 6 )
        match.addTieBreakPoint(team: TEAM_A) // Team A win a tie break point and win the set and the match
        
        XCTAssertEqual(teamA.getCurrentTieBreakPoints(), "0")
        XCTAssertEqual(teamB.getCurrentTieBreakPoints(), "0")
        XCTAssertFalse(match.isTieBreak)
        XCTAssertEqual(teamA.getSet(setIndex: match.getCurrentSet()).getGames(), 7)
        XCTAssertEqual(teamB.getSet(setIndex: match.getCurrentSet()).getGames(), 6)
        XCTAssertEqual(match.getCurrentSet(), 2)
        XCTAssertTrue(match.hasFinished)
        XCTAssertEqual(match.winner?.getName(), teamA.getName())
    }

}

