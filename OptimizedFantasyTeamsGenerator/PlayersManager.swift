//
//  PlayerManager.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/13/23.
//

import Foundation
import SwiftUI

class PlayersManager {
    func getOptimizedTeams() {
        
    }
    
    func downloadStarters() -> [Player] {
        return getBogusStarters()
    }


    private func getBogusStarters() -> [Player] {
        let numberPitchers = 60
        let numberCatchers = 60
        let numberFirstBasemen = 60
        let numberSecondBasemen = 60
        let numberThirdBasemen = 60
        let numberShortStops = 60
        let numberOutfielders = 180
    
        var bogusStarters: [Player] = []
        
        for index in 0 ..< numberPitchers {
            let newName = "Pitcher-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "Pitcher")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "Pitcher")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberCatchers {
            let newName = "Catcher-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "Catcher")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "Catcher")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberFirstBasemen {
            let newName = "1B-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "1B")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "1B")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberSecondBasemen {
            let newName = "2B-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "2B")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "2B")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberThirdBasemen {
            let newName = "3B-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "3B")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "3b")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberShortStops {
            let newName = "SS-\(index)"
            let teamName: String = getTeamName(index: index)
            let cost = getCost(position: "SS")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "SS")
            bogusStarters.append(newPlayer)
        }
        
        for index in 0 ..< numberOutfielders {
            let newName = "OF-\(index)"
            let teamName: String = getTeamName(index: index / 3)
            let cost = getCost(position: "OF")
            let newPlayer = Player(name: newName, team: teamName, cost: cost, position: "OF")
            bogusStarters.append(newPlayer)
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
        
        func getTeamName(index: Int) -> String {
            switch index {
            case 0: fallthrough
            case 1: return "Orioles"
            case 2: fallthrough
            case 3: return "Rays"
            case 4: fallthrough
            case 5: return "Blue Jays"
            case 6: fallthrough
            case 7: return "Red Sox"
            case 8: fallthrough
            case 9: return "Yankees"
            case 10: fallthrough
            case 11: return "Twins"
            case 12: fallthrough
            case 13: return "Guardians"
            case 14: fallthrough
            case 15: return "Tigers"
            case 16: fallthrough
            case 17: return "White Sox"
            case 18: fallthrough
            case 19: return "Royals"
            case 20: fallthrough
            case 21: return "Rangers"
            case 22: fallthrough
            case 23: return "Astros"
            case 24: fallthrough
            case 25: return "Mariners"
            case 26: fallthrough
            case 27: return "Angels"
            case 28: fallthrough
            case 29: return "As"
            case 30: fallthrough
            case 31: return "Braves"
            case 32: fallthrough
            case 33: return "Phillies"
            case 34: fallthrough
            case 35: return "Marlins"
            case 36: fallthrough
            case 37: return "Mets"
            case 38: fallthrough
            case 39: return "Nationals"
            case 40: fallthrough
            case 41: return "Brewers"
            case 42: fallthrough
            case 43: return "Cubs"
            case 44: fallthrough
            case 45: return "Reds"
            case 46: fallthrough
            case 47: return "Pirates"
            case 48: fallthrough
            case 49: return "Cardinals"
            case 50: fallthrough
            case 51: return "Angels"
            case 52: fallthrough
            case 53: return "Giants"
            case 54: fallthrough
            case 55: return "Diamondbacks"
            case 56: fallthrough
            case 57: return "Padres"
            case 58: fallthrough
            case 59: return "Rockies"
            default: return ""
            }
        }
        
        return bogusStarters
    }
    
    /// Uses BEST Evolved Predictor to iterate through players calculating their predictedFantasyScore for today's game
    func getPredictionsForStarters() {
       
    }
    
    var isDownloading: Bool
    
    init() {
        self.isDownloading = false
    }
}

