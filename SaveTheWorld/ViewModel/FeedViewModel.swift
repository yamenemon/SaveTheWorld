//
//  FeedViewModel.swift
//  SaveTheWorld
//
//  Created by Binate Solutions on 19/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

@objc public class FeedViewModel: NSObject {

    func getAllDataFromFirebase(completionhandler : @escaping (Bool,NSMutableArray)-> ()){
        let tableDataArray: NSMutableArray = []

        let ref = Database.database().reference(withPath: "users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            //            print(snapshot.value!)
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let dataObject = child.childSnapshot(forPath: "data")
                let userObject = Users()
                userObject.userID = child.key
                userObject.blood_group = (dataObject.childSnapshot(forPath: "blood_group").value! as! String)
                userObject.email = (dataObject.childSnapshot(forPath: "email").value! as! String)
                userObject.help = (dataObject.childSnapshot(forPath: "help").value! as! String)
                userObject.last_donate_date = (dataObject.childSnapshot(forPath: "last_donate_date").value! as! String)
                userObject.next_eligible_date = (dataObject.childSnapshot(forPath: "next_eligible_date").value! as! String)
                userObject.profil_url = (dataObject.childSnapshot(forPath: "profil_url").value! as! String)
                tableDataArray.add(userObject)
            }
            completionhandler(true,tableDataArray)
        })
    }
}
