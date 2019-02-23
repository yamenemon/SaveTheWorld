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

    let postData = HelpPost()

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
    func setUserPostDataInFirebase(userData: HelpPost, completionhandler : @escaping (Bool)-> ()){
        print(userData)
        userData.postID = UUID().uuidString
        /*
         public var postID: String?
         public var postName: String?
         public var postUserImageUrl: String?
         public var postUserEmail: String?
         public var postUserNeed: String?
         public var postUserLocation: String?
         public var postUserLocationLat: Double?
         public var postUserLocationLong: Double?
         public var postUserName: String?
         public var postUserRelation: String?
         public var postUserSex: String?
         public var postUserAge: Double?
         public var postUserContact: Double?
         public var postUserBloodGroup: String?
         public var postUserDescription: String?
         public var postUserImageOne: UIImage?
         public var postUserImageTwo: UIImage?
         public var postDate: Date?
         */
        if (userData.postName != nil)
            && ((userData.postUserImageUrl != nil)) && ((userData.postUserEmail != nil))
            && ((userData.postUserNeed != nil)) && ((userData.postUserLocation != nil))
            && ((userData.postUserLocationLat != nil)) && ((userData.postUserLocationLong != nil))
            && ((userData.postUserName != nil)) && ((userData.postUserRelation != nil))
            && ((userData.postUserSex != nil)) && ((userData.postUserAge != nil))
            && ((userData.postUserContact != nil)) && ((userData.postUserBloodGroup != nil))
            && ((userData.postUserDescription != nil)){
            
            
            
        }
    }
}
