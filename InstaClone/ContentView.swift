//
//  ContentView.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 18.11.2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    let db = Firestore.firestore()
    var body: some View {
        NavigationView {
            VStack {
                TextField("email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: signIn) {
                    Text("SignIn")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.mint)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: signUp) {
                    Text("SignUp")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: FeedView(), isActive: $isLoggedIn) {
                    EmptyView() // Go to feed automatically when logged in
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Login")
        }
    }
    
    func signIn() {
        if email.isEmpty || password.isEmpty {
            makeAlert(title: "Error", message: "Username/password cannot be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                isLoggedIn = true
            }
        }
    }
    
    func signUp() {
        if email.isEmpty || password.isEmpty {
            makeAlert(title: "Error", message: "Username/password cannot be empty")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                //save to firestoredb:
                var ref : DocumentReference? = nil
                 
                let dict : [String : Any] = ["emil": self.email]
                ref = self.db.collection("Users").addDocument(data: dict, completion: { (error) in
                    if error != nil {
                        
                    }
                })
            }
        }
    }
    
    func makeAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
}
