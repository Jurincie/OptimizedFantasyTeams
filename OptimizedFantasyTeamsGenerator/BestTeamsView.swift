//
//  BestTeamsView.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/14/23.
//

import SwiftUI
import SwiftData

struct BestTeamsView: View {
    @Query private var starters: [Player]
    @State private var sortedTeams: [Team] = []
    let playersManager = PlayersManager.shared
    
    var body: some View {
        List(sortedTeams) { team in
            TeamView(team: team)
        }.task {
            let best = await playersManager.getOptimizedTeams(starters: starters)
            sortedTeams.append(contentsOf: best)
        }
    }
}

struct TeamView: View {
    var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    var body: some View {
        VStack{
            VStack {
                Text("Cost: \(team.budget)")
                Text("Projected Score: \(team.projectedScore)")
                Divider()
            }
            VStack {
                Text(team.pitcher1?.name ?? "")
                Text(team.pitcher2?.name ?? "")
                Text(team.catcher?.name ?? "")
                Text(team.firstBaseman?.name ?? "")
                Text(team.secondBaseman?.name ?? "")
                Text(team.thirdBaseman?.name ?? "")
                Text(team.shortStop?.name ?? "")
                Text(team.outfield1?.name ?? "")
                Text(team.outfield2?.name ?? "")
                Text(team.outfield3?.name ?? "")
            }
        }
    }
}

//#Preview {
//    BestTeamsView(teams: playersManager.getOptimizedTeams(starters: starters))
//}
