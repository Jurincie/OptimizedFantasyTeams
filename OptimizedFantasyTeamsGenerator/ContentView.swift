//
//  ContentView.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/13/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: StartersView()) {
                Text("Get Starters")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Player.self, inMemory: true)
}
