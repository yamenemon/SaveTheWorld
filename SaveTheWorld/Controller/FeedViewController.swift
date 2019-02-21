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
import SCLAlertView



class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var helpTextBtn: UIButton!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var feedTableView: UITableView!
    var tableDataArray: NSMutableArray = []
    var alertView: SCLAlertView!
    
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
        self.tabBarController?.navigationItem.title = "Help Needed"

        feedTableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")

        let feedViewmodel = FeedViewModel()
        feedViewmodel.getAllDataFromFirebase { completed, result in
            if completed == true {
                print("entering")
                self.tableDataArray = result
                self.feedTableView.reloadData()
            }
        }
    }
    override func viewWillLayoutSubviews() {
        helpTextBtn.layer.cornerRadius = 15.0
        helpTextBtn.layer.borderWidth = 1.0
        helpTextBtn.layer.borderColor = UIColor.black.cgColor
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableDataArray.count > 0 {
            return self.tableDataArray.count
        }
        else {
            return 0
        }
    }
    @IBAction func helpBtnAction(_ sender: Any) {
//        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpWindow") as! HelpPopUpViewController

        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: false
        )
        alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Facebook", target:self, selector:#selector(FeedViewController.facebookBtnAction))
        alertView.addButton("Twitter") {
            print("Twitter button tapped")
        }
        alertView.showSuccess("Login", subTitle: "Before Post Please Login")
    }
    @objc func facebookBtnAction() {
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            if let dic = dataDictionary {
                print(dic)
            }
            if let dic = error {
                print(dic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let staticString = "FeedTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: staticString, for: indexPath as IndexPath) as? FeedTableViewCell
        cell?.backgroundColor = Singleton.sharedInstance().hexStringToUIColor(hex: "0x154521")
        let userObject = self.tableDataArray[indexPath.row] as! Users
        cell?.userHelpText.text = userObject.help
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
}
