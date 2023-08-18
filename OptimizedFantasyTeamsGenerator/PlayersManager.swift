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
    
    func getOptimizedTeams(starters: [Player]) -> [Team] {
        func getBestTeamsWithThisPitcher(pitcher1: Player) -> [Team] {
            func shouldAddThisTeam(projectedScore: Int) -> Bool {
                if tooManyPlayersFromSameTeam() {
                    return false
                }
                
                return sortedTopTeams.count < kNumberTopTeams || sortedTopTeams[0].projectedScore < projectedScore
            }
            
            func tooManyPlayersFromSameTeam() -> Bool {
                var teamsArray: [String] = [firstBase.team, secondBase.team, thirdBase.team, shortStop.team, outfield1.team, outfield2.team, outfield3.team, pitcher1.team, pitcher2.team, catcher.team]
                
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
                return firstBase.cost + secondBase.cost + thirdBase.cost + shortStop.cost + outfield1.cost + outfield2.cost + outfield3.cost + pitcher1.cost + pitcher2.cost + catcher.cost
            }
            
            func getTeamProjectedScore() -> Int {
                return Int(firstBase.score + secondBase.score + thirdBase.score + shortStop.score + outfield1.score + outfield2.score + outfield3.score + pitcher1.score + pitcher2.score + catcher.score)
            }
            
            var thisPitchersBestTeams: [Team] = []
            var firstBase: Player
            var secondBase: Player
            var thirdBase: Player
            var shortStop: Player
            var catcher: Player
            var pitcher2: Player
            var outfield1: Player
            var outfield2: Player
            var outfield3: Player
                
            for pitch in pitchers {
                if pitch == pitcher1 {
                    continue
                }
                pitcher2 = pitch
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
                                    
                                    for lf in outfielders {
                                        outfield1 = lf
                                        for cf in outfielders {
                                            if cf == outfield1 {
                                                continue
                                            }
                                            outfield2 = cf
                                            let availableOutfielders = outfielders.filter({$0.name != outfield1.name && $0.name != outfield2.name})
                                            for rf in availableOutfielders {
                                                outfield3 = rf
                                                totalPossibleTeams += 1
                                                if totalPossibleTeams % 100_000 == 0 {
                                                    print("-----> \(totalPossibleTeams) processed")
                                                }
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
                                                                       pitcher1: pitcher1,
                                                                       pitcher2: pitcher2,
                                                                       catcher: catcher)
                                                        
                                                        if thisPitchersBestTeams.count == kNumberTopTeams {
                                                            thisPitchersBestTeams.removeFirst()
                                                        }
                                                        thisPitchersBestTeams.append(newTeam!)
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
        
            return thisPitchersBestTeams.sorted()
        }
        
        let kNumberTotalTopTeams = 10
        let kMaxPlayersFromSameTeam = 5
        var totalPossibleTeams = 0
        let kMaxBudget = 50000
        let kNumberTopTeams = 3
        var sortedTopTeams: [Team] = []
        var newTeam: Team?
        let firstBasemen    = starters.filter({$0.position == "1B"})
        let secondBasemen   = starters.filter({$0.position == "2B"})
        let thirdBasemen    = starters.filter({$0.position == "3B"})
        let shortStops      = starters.filter({$0.position == "1B"})
        let pitchers        = starters.filter({$0.position == "Pitcher"})
        let catchers        = starters.filter({$0.position == "Catcher"})
        let outfielders     = starters.filter({$0.position == "OF"})
       
        for pitcher in pitchers {
            let thisPitchersBestTeams = getBestTeamsWithThisPitcher(pitcher1: pitcher)
            sortedTopTeams.append(contentsOf: thisPitchersBestTeams)
        }
            
        print("total possible teams: \(totalPossibleTeams)")
        
        // ONLY return 10 best teams
//        if sortedTopTeams.count > kNumberTotalTopTeams {
//            sortedTopTeams.removeSubrange(10...)
//        }
        
        return sortedTopTeams.sorted()
    }
    
    func downloadStarters() -> [Player] {
        return getBogusStarters()
    }

    private func getBogusStarters() -> [Player] {
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
        let kNumberCatchers = 4
        let kNumberFirstBasemen = 4
        let kNumberSecondBasemen = 4
        let kNumberThirdBasemen = 4
        let kNumberShortStops = 4
        let kNumberOutfielders = 6
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
    
    init() {}
    
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

