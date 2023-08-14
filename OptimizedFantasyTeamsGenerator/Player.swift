//
//  Item.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/13/23.
//

import Foundation
import SwiftData

@Model
final class Player {
    @Attribute(.unique) var name: String
    var cost: Int
    var score: Double
    var position: String
    var team: String
    
    init(name: String, team: String, cost: Int = 0, score: Double = 0.00, position: String = "") {
        self.name = name
        self.team = team
        self.cost = cost
        self.score = score
        self.position = position
    }
}
