//
//  UploadView.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 18.11.2024.
//

import SwiftUI
import Firebase
import PhotosUI
struct UploadView: View {
    @State private var comments = ""
    @State private var selectedItem : PhotosPickerItem?
    @State private var data : Data?
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    
    var body: some View {
        VStack{
            TextField("Comments", text: $comments)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("select Image")
            }
            //selectedıtem kullanma, photospicker değişince ne olacak
            .onChange(of: selectedItem) { newValue in
                //selectedıtem değişkeni değiştiğinde ne yapılacak:
                guard let item = selectedItem else {
                    return
                }
                //selectedıtem photospickerıtem olarak verildiği için tek bir ıtema çeviriyorum loadtransferablea vereyim ve o da dataya çevirsin
                item.loadTransferable(type: Data.self) { result in
                    switch result{
                        //seçilen fotoyu 021 gibi dataya çevirip state data değişkenine atıyor
                    case .success(let data):
                        if let data = data{
                            self.data = data
                        }
                    case .failure(let error):
                        print("Failed to load image data: \(error)")
                    }
                }
            }
            Button(action: uploadImage){
                Text("Upload Image")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
                
            }
            
        }
        .padding()
    }
    
    func uploadImage(){
        guard let data = data else {
            makeAlert(title: "error", message: "no image selected")
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference()
            .child("images/\(fileName)")
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                makeAlert(title: "error", message: "failed to upload image")
            } else{
                storageRef.downloadURL{
                    (url, error) in
                    if error == nil {
                        let imageUrl = url?.absoluteString
                        //Database
                        let firestoreDB = Firestore.firestore()
                        
                        var firestoreRef : DocumentReference? = nil
                        let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!,"postcomment" : $comments, "date" : FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                         firestoreRef = firestoreDB.collection("Posts").addDocument(data: firestorePost) { (error) in
                            if error != nil {
                                makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                            }else {
                                resetView()
                            }
                        }
                    }
                }
            }
            
        }
        
        func makeAlert(title: String, message: String){
            alertTitle = title
            alertMessage = message
            showAlert = true
        }
    }
    func resetView() {
        comments = ""
        selectedItem = nil
        data = nil
    }
    
}
    
       
    


#Preview {
    UploadView()
}

