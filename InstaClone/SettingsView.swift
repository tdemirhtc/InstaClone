//
//  SettingsView.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 18.11.2024.
//

import SwiftUI
import Firebase
struct SettingsView: View {
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                NavigationLink(destination: ContentView()){
                    Button(action: signOut) {
                        Text("SignOut")
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                }
            }
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        
        }catch{
            print("Error signing out: \(error.localizedDescription)")
            
        }
    }
}


#Preview {
    SettingsView()
}

