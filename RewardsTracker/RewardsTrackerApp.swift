//
//  RewardsTrackerApp.swift
//  RewardsTracker
//
//  Created by Tyler Rong on 12/1/24.
//

import SwiftUI
import CoreData

@main
struct RewardsTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("hasLoadedSampleData") private var hasLoadedSampleData = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    if !hasLoadedSampleData {
                        SampleData.loadSampleData(context: persistenceController.container.viewContext)
                        hasLoadedSampleData = true
                    }
                }
        }
    }
}
