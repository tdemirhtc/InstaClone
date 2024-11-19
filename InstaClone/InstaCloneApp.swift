//
//  InstaCloneApp.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 18.11.2024.
//

import SwiftUI
import Firebase

@main
struct InstaCloneApp: App {
   
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            let currentUser = Auth.auth().currentUser
            if currentUser != nil{
                ContentView()
            }
         
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView{
            FeedView()
                .tabItem {
                    Label("Feed",systemImage: "house")
                }
            UploadView()
                .tabItem {
                    Label("Upload", systemImage: "plus.circle")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

