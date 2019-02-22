//
//  HelpPopUpViewController.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 20/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import SDWebImage

class HelpPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    let typesOfOrgan = ["Blood","Kidney","Heart","Lung","Lever","Eye"]
    let typesOfSex = ["Male","Female"]
    let typesOfBlood = ["O-","O+","A-","A+","B-","B+","AB-","AB+"]



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        DispatchQueue.main.async(execute: {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            self.needTextField.inputView = pickerView
            self.patientSex.inputView = pickerView
            self.patientBloodGroupField.inputView = pickerView
        })
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
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return typesOfOrgan.count
        } else if pickerView.tag == 3 {
            return typesOfSex.count
        }
        else if pickerView.tag == 6 {
            return typesOfBlood.count
        }
    return 0
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return typesOfOrgan[row]
        } else if pickerView.tag == 3 {
            return typesOfSex[row]
        } else if pickerView.tag == 6 {
            return typesOfBlood[row]
        }
    return nil
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            needTextField.text = typesOfOrgan[row]
        } else if pickerView.tag == 3 {
            needTextField.text = typesOfSex[row]
        } else if pickerView.tag == 6 {
            needTextField.text = typesOfBlood[row]
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

