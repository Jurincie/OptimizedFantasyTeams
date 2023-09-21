//
//  PlayerManager.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/13/23.
//

import Foundation
import SwiftUI

class PlayersManager {
    static var shared = PlayersManager()
    
    init() {}
    
    func getOptimizedTeams(starters: [Player]) async -> [Team] {
        let kMaxPlayersFromSameTeam = 5
        let kMaxBudget = 50000
        let firstBasemen    = starters.filter({$0.position == "1B"})
        let secondBasemen   = starters.filter({$0.position == "2B"})
        let thirdBasemen    = starters.filter({$0.position == "3B"})
        let shortStops      = starters.filter({$0.position == "1B"})
        let pitchers        = starters.filter({$0.position == "Pitcher"})
        let catchers        = starters.filter({$0.position == "Catcher"})
        let outfielders     = starters.filter({$0.position == "OF"})
        
        // Here we use swift concurrency to use max cores via TaskGroup
        let best = await withTaskGroup(of: Team.self) { group -> [Team] in
            for pitcher in pitchers {
                // Since no team will ever make it from the HighestInexPitcher skip him
                if getPositionIndex(pitcher.name) >= pitchers.count - 1 {
                    continue
                }
                group.addTask {
                    return await getBestTeamWithThisPitcher(firstPitcher: pitcher)
                }
            }
            
            var bestTeams = [Team]()
            
            for await value in group {
                bestTeams.append(value)
            }
            
            return bestTeams
        }
        
        return best.sorted()
        
        // Mark: func methods
        @Sendable func getBestTeamWithThisPitcher(firstPitcher: Player) async -> Team {
            var firstBase: Player
            var secondBase: Player
            var thirdBase: Player
            var shortStop: Player
            var catcher: Player
            var secondPitcher: Player
            var outfield1: Player
            var outfield2: Player
            var outfield3: Player
            var newTeam: Team?
            var bestTeam: Team?
            
            // to avoid duplicate teams we only allow teams where implied index of pitcher1 < pitcher2
            for pitcher2 in pitchers {
                let firstPitcherIndex = getPositionIndex(firstPitcher.name)
                let secondPitcherIndex = getPositionIndex(pitcher2.name)

                if secondPitcherIndex <= firstPitcherIndex {
                    continue
                }
                
                print("\(Thread.current) -> 1st: \(firstPitcherIndex) --- 2nd: \(secondPitcherIndex)")

                secondPitcher = pitcher2
                for firstBaseman in firstBasemen {
                    firstBase = firstBaseman
                    for secondBaseman in secondBasemen {
                        secondBase = secondBaseman
                        for thirdBaseman in thirdBasemen {
                            thirdBase = thirdBaseman
                            for ss in shortStops {
                                shortStop = ss
                                for thisCatcher in catchers {
                                    catcher = thisCatcher
                                    for of1 in outfielders {
                                        outfield1 = of1
                                        for of2 in outfielders {
                                            if getPositionIndex(of2.name) <= getPositionIndex(outfield1.name) {
                                                continue
                                            }
                                            outfield2 = of2
                                            for of3 in outfielders {
                                                if getPositionIndex(of3.name) <= getPositionIndex(outfield2.name) {
                                                    continue
                                                }
                                                outfield3 = of3
                                                
                                                let teamCost = getTeamCost()
                                                if teamCost <= kMaxBudget {
                                                    let projectedScore = getTeamProjectedScore()
                                                    if shouldAddThisTeam(projectedScore: projectedScore) {
                                                        newTeam = Team(budget: teamCost,
                                                                       projectedScore: projectedScore,
                                                                       firstBaseman: firstBase,
                                                                       secondBaseman: secondBase,
                                                                       thirdBaseman: thirdBase,
                                                                       shortStop: shortStop,
                                                                       outfield1: outfield1,
                                                                       outfield2: outfield2,
                                                                       outfield3: outfield3,
                                                                       pitcher1: firstPitcher,
                                                                       pitcher2: pitcher2,
                                                                       catcher: catcher)
                                                        
                                                        if bestTeam == nil {
                                                            bestTeam = newTeam!
                                                        } else {
                                                            if newTeam!.projectedScore > bestTeam!.projectedScore {
                                                                bestTeam = newTeam!
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
            assert(bestTeam != nil, "No Team made it")
            return bestTeam!
            
            // Mark: func methods
            func shouldAddThisTeam(projectedScore: Int) -> Bool {
                if tooManyPlayersFromSameTeam() {
                    return false
                } else {
                    return true
                }
            }
            
            func tooManyPlayersFromSameTeam() -> Bool {
                let teamsArray: [String] = [firstBase.team, secondBase.team, thirdBase.team, shortStop.team, outfield1.team, outfield2.team, outfield3.team, firstPitcher.team, secondPitcher.team, catcher.team]
                
                let mappedItems = teamsArray.map { ($0, 1) }
                let counts = Dictionary(mappedItems, uniquingKeysWith: +)
                
                for item in counts {
                    if item.value > kMaxPlayersFromSameTeam {
                        return true
                    }
                }
                
                return false
            }
            
            func getTeamCost() -> Int {
                return firstBase.cost + secondBase.cost + thirdBase.cost + shortStop.cost + outfield1.cost + outfield2.cost + outfield3.cost + firstPitcher.cost + secondPitcher.cost + catcher.cost
            }
            
            func getTeamProjectedScore() -> Int {
                return Int(firstBase.score + secondBase.score + thirdBase.score + shortStop.score + outfield1.score + outfield2.score + outfield3.score + firstPitcher.score + secondPitcher.score + catcher.score)
            }
            
        }
    }

    func downloadStarters() -> [Player] {
        return getBogusStarters()
    }

    func getBogusStarters() -> [Player] {
        /// Uses BEST Evolved Predictor to iterate through players calculating their predictedFantasyScore for today's game
        func getPrediction() -> Double {
            let intValue = Int.random(in: 5...69)
            return Double(intValue)
        }
        
        func getCost(position: String) -> Int {
            var cost: Int
            switch position{
            case "Pitcher": cost = Int.random(in: 40...110)
            case "Catcher": cost = Int.random(in: 20...55)
            case "1B": cost = Int.random(in: 20...50)
            case "2B": cost = Int.random(in: 20...61)
            case "3B": cost = Int.random(in: 20...62)
            case "SS": cost = Int.random(in: 20...63)
            case "OF": cost = Int.random(in: 20...50)
            default: cost = 0
            }
            
            return cost * 100
        }
        
        func getTeamName() -> String {
            return Teams.allCases.randomElement()?.rawValue ?? ""
        }
        
        let kNumberPitchers = 8
        let kNumberCatchers = 5
        let kNumberFirstBasemen = 5
        let kNumberSecondBasemen = 5
        let kNumberThirdBasemen = 5
        let kNumberShortStops = 5
        let kNumberOutfielders = 8
        var bogusStarters: [Player] = []
        
        for index in 0 ..< kNumberPitchers {
            let newName = "Pitcher-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "Pitcher"),
                                   score: getPrediction(),
                                   position: "Pitcher")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberCatchers {
            let newName = "Catcher-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "Catcher"),
                                   score: getPrediction(),
                                   position: "Catcher")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberFirstBasemen {
            let newName = "1B-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "1B"),
                                   score: getPrediction(),
                                   position: "1B")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberSecondBasemen {
            let newName = "2B-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "2B"),
                                   score: getPrediction(),
                                   position: "2B")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberThirdBasemen {
            let newName = "3B-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "3B"),
                                   score: getPrediction(),
                                   position: "3B")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberShortStops {
            let newName = "SS-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "SS"),
                                   score: getPrediction(),
                                   position: "SS")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< kNumberOutfielders {
            let newName = "OF-\(index)"
            let teamName: String = getTeamName()
            let newPlayer = Player(name: newName,
                                   team: teamName,
                                   cost: getCost(position: "OF"),
                                   score: getPrediction(),
                                   position: "OF")
            
            bogusStarters.append(newPlayer)
        }
        
        return bogusStarters
    }
    
    /// - Parameter name: String of the form: "Pitcher-1", "OF-6", "Pitcher-12" etc.
    /// - Returns: number contained in string AFTER the only "-" character
    private func getPositionIndex(_ name: String) -> Int {
        guard name.count > 3 else { return 0 }
            
        let splitStrings = name.split(separator: "-")
        assert(splitStrings.count == 2, "Illegal name argument")
        return Int(splitStrings[1])!
    }
    
    enum Teams: String, CaseIterable {
        case rockies = "Rockies"
        case padres = "Padres"
        case diamondbacks = "Diamondbacks"
        case giants = "Giants"
        case cardinals = "Cardinals"
        case pirates = "Pirates"
        case reds = "Reds"
        case cubs = "Cubs"
        case brewers = "Brewers"
        case nationals = "Nationals"
        case marlins = "Marlins"
        case phillies = "Phillies"
        case braves = "Braves"
        case athletics = "Athletics"
        case angels = "Angels"
        case mariners = "Mariners"
        case royals = "Royals"
        case astros = "Astros"
        case rangers = "Rangers"
        case whiteSox = "White Sox"
        case tigers = "Tigers"
        case guardians = "Guardians"
        case twins = "Twins"
        case redSox = "Red Sox"
        case blueJays = "Blue Jays"
        case rays = "Rays"
        case orioles = "Orioles"
    }
}

