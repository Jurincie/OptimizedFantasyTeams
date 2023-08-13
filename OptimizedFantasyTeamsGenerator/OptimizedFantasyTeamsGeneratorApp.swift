//
//  OptimizedFantasyTeamsGeneratorApp.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/13/23.
//

import SwiftUI
import SwiftData

@main
struct OptimizedFantasyTeamsGeneratorApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
