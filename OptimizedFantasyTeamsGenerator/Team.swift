//
//  Team.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/14/23.
//

import Foundation
import SwiftData

struct Team: Identifiable, Comparable {
    static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.projectedScore < rhs.projectedScore
    }
    
    let id = UUID().uuidString
    var budget: Int
    let maxBudget = 0
    var projectedScore: Int
    
    let firstBaseman: Player?
    let secondBaseman: Player?
    let thirdBaseman: Player?
    let shortStop: Player?
    let outfield1: Player?
    let outfield2: Player?
    let outfield3: Player?
    let pitcher1: Player?
    let pitcher2: Player?
    let catcher: Player?
    
    init(budget: Int,
         projectedScore: Int,
         firstBaseman: Player?,
         secondBaseman: Player?,
         thirdBaseman: Player?,
         shortStop: Player?,
         outfield1: Player?,
         outfield2: Player?,
         outfield3: Player?,
         pitcher1: Player?,
         pitcher2: Player?,
         catcher: Player?) {
        self.budget = budget
        self.projectedScore = projectedScore
        self.firstBaseman = firstBaseman
        self.secondBaseman = secondBaseman
        self.thirdBaseman = thirdBaseman
        self.shortStop = shortStop
        self.outfield1 = outfield1
        self.outfield2 = outfield2
        self.outfield3 = outfield3
        self.pitcher1 = pitcher1
        self.pitcher2 = pitcher2
        self.catcher = catcher
    }
}
