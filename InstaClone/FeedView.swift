//
//  FeedView.swift
//  InstaClone
//
//  Created by Hatice Taşdemir on 18.11.2024.
//


import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Firebase
struct FeedView: View {
    @StateObject private var postModel = PostModel()
    
    var body: some View {
        NavigationView{
            List(postModel.posts) { post in
                VStack(alignment: .leading, spacing: 10) {
                    WebImage(url: URL(string: post.imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)
                    Text(post.email)
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text(post.comment)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    //likes and btn
                    HStack{
                        Text("\(post.likes) Likes")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Like button pressed for post: \(post.id)")
                            postModel.likePost(postId: post.id)
                        }) {
                            Text("Like")
                                .font(.footnote)
                                .foregroundColor(.brown)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("FEED")
        }
    }
    
   
    
   /* func increaseLikeCount(for post: Post) {
        let db = Firestore.firestore()
        let postRef = db.collection("posts").document(post.id)
        
        postRef.updateData(["likes" : FieldValue.increment(Int64(1))]) { (error) in
            if let error = error {
                print()
            }else{
                if let index = postModel.posts.firstIndex(where: { $0.id == post.id }) {
                    postModel.posts[index].likes += 1
                                }
            }
        }
    } */
}


#Preview {
    FeedView()
}


