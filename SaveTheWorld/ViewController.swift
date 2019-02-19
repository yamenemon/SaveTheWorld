//
//  ViewController.swift
//  SaveTheWorld
//
//  Created by Binate Solutions on 17/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        var ref: DatabaseReference!
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd, H:mm:ss"
//        let defaultTimeZoneStr = formatter.string(from: Date())
//        ref = Database.database().reference()
//        let post =  ["data":["username": "Elora",
//                    "email": "fardowsy@gmail.com",
//                    "profil_url": "url",
//                    "blood_group": "O+",
//                    "help": "I need Blood",
//                    "last_donate_date": defaultTimeZoneStr,
//                    "next_eligible_date": defaultTimeZoneStr]]
//        let posts =  ["data":["username": "Yamen Emon",
//                             "email": "ios.emon@gmail.com",
//                             "profil_url": "url",
//                             "blood_group": "O+",
//                             "help": "I need Blood",
//                             "last_donate_date": defaultTimeZoneStr,
//                             "next_eligible_date": defaultTimeZoneStr]]
//        ref.child("users").childByAutoId().updateChildValues(post)
//        ref.child("users").childByAutoId().updateChildValues(posts)
        let ref = Database.database().reference(withPath: "users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
//            print(snapshot) // Its print all values including Snap (User)
            
//            print(snapshot.value!)
            
            let username = snapshot.childSnapshot(forPath: "username").value
            print(username!)
            
        })
    }
}

