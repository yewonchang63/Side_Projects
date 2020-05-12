//
//  FeedData.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Create global instance of the feed
var feed = FeedData()



class Thread {
    let dbt = Firestore.firestore()
    let storaget = Storage.storage()


    var name: String
    var emoji: String
    var entries: [ThreadEntry]
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.entries = []
    }
    
    func addEntry(threadEntry: ThreadEntry) {
        entries.append(threadEntry)
        let user = threadEntry.username
        let threadImageId = UUID.init().uuidString
        
        let storageReft = storaget.reference(withPath: "threadImages/\(threadImageId).jpg")
        guard let imageData = threadEntry.image.jpegData(compressionQuality: 0.75) else {return}
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageReft.putData(imageData)
        
        var ref: DocumentReference? = nil
        ref = dbt.collection("threadImages").addDocument(data: [
            "username" : user,
            "threadImage": threadImageId
        ]) {err in
            if let err = err {
                print ("Error adding document: \(err)")
            }
            else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
           
    }
    //"images" -> uique image id, timestamp
    
   
    
    
    func removeFirstEntry() -> ThreadEntry? {
        if entries.count > 0 {
            return entries.removeFirst()
        }
        return nil
    }
    
    func unreadCount() -> Int {
        return entries.count
    }
}

struct ThreadEntry {
    var username: String
    var image: UIImage
}

struct Post {
    var location: String
    var image: UIImage?
    var user: String
    var caption: String
    var date: Date
}

class FeedData {
    let db = Firestore.firestore()
    let storage = Storage.storage()

    func fetch() {
        db.collection("threadImages").getDocuments() { (QuerySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
                     
            for document in QuerySnapshot!.documents {
                print(document.data())
                    }
                }
        }
        
        db.collection("postImages").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    print(document.data())
                }
            }
        }
    }
    var username = "aliceissocoolxd"
    
    var threads: [Thread] = [
        Thread(name: "memes", emoji: "😂"),
        Thread(name: "dogs", emoji: "🐶"),
        Thread(name: "fashion", emoji: "🕶"),
        Thread(name: "fam", emoji: "👨‍👩‍👧‍👦"),
        Thread(name: "tech", emoji: "💻"),
        Thread(name: "eats", emoji: "🍱"),
    ]

    // Adds dummy posts to the Feed
    var posts: [Post] = [
        Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date()),
        Post(location: "Memorial Stadium", image: UIImage(named: "garbers"), user: "rjpimentel", caption: "Last Cal Football game of senior year!", date: Date()),
        Post(location: "Soda Hall", image: UIImage(named: "soda"), user: "chromadrive", caption: "Find your happy place 💻", date: Date())
    ]
    
    // Adds dummy data to each thread
    init() {
        for thread in threads {
            let entry = ThreadEntry(username: self.username, image: UIImage(named: "garbers")!)
            thread.addEntry(threadEntry: entry)
        }
    }
    
    func addPost(post: Post) {
        posts.append(post)
        
        let user = post.user
        let postImageID = UUID.init().uuidString
        let location = post.location
        let time = Timestamp(date: post.date)
        let caption = post.caption
        
        let storageRefp = storage.reference(withPath: "postImages/\(postImageID).jpg")
        guard let imageData = post.image!.jpegData(compressionQuality: 0.75) else {return}
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRefp.putData(imageData)
        
        
        var refp: DocumentReference? = nil
        refp = db.collection("postImages").addDocument(data: [
            "username" : user,
            "postImageID": postImageID,
            "location" : location,
            "time" : time,
            "caption": caption
        ]) {err in
            if let err = err {
                print ("Error adding document: \(err)")
            }
            else {
                print("Document added with ID: \(refp!.documentID)")
            }
        }
        
    }
    
    // Optional: Implement adding new threads!
    func addThread(thread: Thread) {
        threads.append(thread)
    }
}

// write firebase functions here (pushing, pulling, etc.) 
