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
    @State private var showingSheet = false
    var count = 0
    var playersManager = PlayersManager()
    
    var body: some View {
        VStack {
            Button("Get Optimal Teams") {
                showingSheet.toggle()
            }
            .font(.largeTitle)
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showingSheet) {
                BestTeamsView(teams: playersManager.getOptimizedTeams(starters: starters))
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
    
    func getOptimalTeamsForTodaysGames() {
        
    }
}

#Preview {
    StartersView()
}
