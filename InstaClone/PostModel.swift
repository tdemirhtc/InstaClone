//
//  PostModel.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 19.11.2024.
//

import Foundation
import Firebase
import SwiftUI

struct Post: Identifiable {
    var id: String
    var email: String
    var comment: String
    var imageURL: String
    var likes: Int

}

class PostModel: ObservableObject {
    @Published var posts : [Post] = []
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts").order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil{
                print("error")
            }else{
                if let snapshot = snapshot {
                               for document in snapshot.documents {
                                   let id = document.documentID
                                  
                                   let email = document.get("postedBy") as? String ?? "Unknown"
                                   let comment = document.get("postComment") as? String ?? "No comment"
                                   let likes = document.get("likes") as? Int ?? 0
                                   let imageURL = document.get("imageUrl") as? String ?? ""
                                   
                                   // Post nesnesini oluşturup posts dizisine ekliyoruz
                                   let post = Post(id: id, email: email, comment: comment, imageURL: imageURL, likes: likes)
                                   self.posts.append(post)
                               }
                           }
                       }
                   }
               }
    
    func likePost(postId: String) {
        let db = Firestore.firestore()
        
        // Firestore'da ilgili post'u bulup likes sayısını arttırıyoruz.
        db.collection("posts").document(postId).updateData([
            "likes": FieldValue.increment(Int64(1)) // Beğeni sayısını 1 artırıyoruz
        ]) { error in
            if let error = error {
                print("Error updating like count: \(error.localizedDescription)")
            } else {
                print("Successfully liked the post")
            }
        }
    }
    
        }
    


