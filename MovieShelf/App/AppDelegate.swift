//
//  AppDelegate.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit
import SwiftData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private(set) var modelContainer: ModelContainer?
       var modelContext: ModelContext? { modelContainer?.mainContext }

    override init() {
        super.init()
        do {
            let schema = Schema([FavoriteMovie.self])
            modelContainer = try ModelContainer(for: schema)
        } catch {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            modelContainer = try? ModelContainer(for: Schema([FavoriteMovie.self]), configurations: config)
            print("SwiftData fallback (in-memory). Error:", error)
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool { true }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

