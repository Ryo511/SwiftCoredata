//
//  IOS203PhotoMap_33App.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/5/21.
//

import SwiftUI
import CoreData

@main
struct IOS203PhotoMap_33App: App {
    
    let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    var managedObjectContext: NSManagedObjectContext {
           return persistentContainer.viewContext
       }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, managedObjectContext)
        }
    }
}
