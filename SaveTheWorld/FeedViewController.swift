//
//  FeedViewController.swift
//  SaveTheWorld
//
//  Created by Binate Solutions on 19/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class FeedViewController: UIViewController {

    var tableDataArray: NSMutableArray = []
    
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
        let feedViewmodel = FeedViewModel()
        feedViewmodel.getAllDataFromFirebase { completed, result in
            if completed == true {
                print("entering")
                self.tableDataArray = result
            }
        }
    }
    


}
