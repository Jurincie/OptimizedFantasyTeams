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
    var count = 0
    var playersManager = PlayersManager()
    
    var body: some View {
        VStack {
            NavigationLink {
                BestTeamsView()
            } label: {
                Text("Calculate Best Teams")
            }
            Spacer()
            List(starters) { starter in
                HStack {
                    Text(starter.team)
                    Text(starter.name)
                    Spacer()
                    Text("\(Int(starter.score))")
                    Text("\(starter.cost)")
                }
            }.onAppear(perform: {
                loadStarters()
            })
        }
    }
    
    private func addPlayer(player: Player) {
        withAnimation {
            modelContext.insert(player)
        }
    }
    
    func loadStarters() {
        let todaysStarters = playersManager.downloadStarters()
        
        for starter in todaysStarters {
            print("\(starter.name)")
            addPlayer(player: starter)
        }
    }
}

#Preview {
    StartersView()
}
