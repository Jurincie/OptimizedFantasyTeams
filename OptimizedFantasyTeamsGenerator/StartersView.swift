//
//  StartersView.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/14/23.
//

import SwiftUI
import SwiftData

struct StartersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var starters: [Player]
    var playerManager = PlayersManager()
    
    var body: some View {
        Spacer()

        List(starters) { starter in
            HStack {
                Text(starter.name)
                Text(starter.team)
                Spacer()
                Text("\(starter.cost)")
            }
        }.onAppear(perform: {
            loadStarters()
        })
    }
    
    private func addPlayer(player: Player) {
        withAnimation {
            modelContext.insert(player)
        }
    }
    
    func loadStarters() {
        let todaysStarters = playerManager.downloadStarters()
        
        for starter in todaysStarters {
            addPlayer(player: starter)
        }
    }
    
    func getOptimalTeamsForTodaysGames() {
        
    }
}

#Preview {
    StartersView()
}
