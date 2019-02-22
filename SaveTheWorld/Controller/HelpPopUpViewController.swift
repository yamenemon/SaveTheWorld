//
//  HelpPopUpViewController.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 20/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import SDWebImage

class HelpPopUpViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var needTextField: MyCustomTextField!
    @IBOutlet weak var patientNameTextField: MyCustomTextField!
    @IBOutlet weak var patientRelationTextField: MyCustomTextField!
    @IBOutlet weak var patientSex: MyCustomTextField!
    @IBOutlet weak var patientAge: MyCustomTextField!
    @IBOutlet weak var emegencyContactTextField: MyCustomTextField!
    @IBOutlet weak var patientBloodGroupField: MyCustomTextField!
    @IBOutlet weak var patientDescriptionField: UITextView!
    
    
    public var userData: NSMutableDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }
    override func viewWillLayoutSubviews() {
        userImage.layer.cornerRadius = (userImage.frame.size.height)/2
        userImage.clipsToBounds = true
        
        patientDescriptionField.layer.borderColor = UIColor.lightGray.cgColor
        patientDescriptionField.layer.borderWidth = 1.0
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        self.title = "Post Description"
        
        guard let userInfo = userData else { return } //handle the error
        setUserDataInField(userData: userInfo)
    }
    func setUserDataInField(userData: NSMutableDictionary) {
        
        userName.text = userData["name"] as? String
        if let imageURL = ((userData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
            userImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "SaveLives"))

        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

