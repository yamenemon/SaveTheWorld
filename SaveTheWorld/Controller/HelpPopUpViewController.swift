//
//  HelpPopUpViewController.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 20/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class HelpPopUpViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, getUserLocationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var needTextField: MyCustomTextField!
    @IBOutlet weak var LocationTextField: MyCustomTextField!
    @IBOutlet weak var patientNameTextField: MyCustomTextField!
    @IBOutlet weak var patientRelationTextField: MyCustomTextField!
    @IBOutlet weak var patientSex: MyCustomTextField!
    @IBOutlet weak var patientAge: MyCustomTextField!
    @IBOutlet weak var emegencyContactTextField: MyCustomTextField!
    @IBOutlet weak var patientBloodGroupField: MyCustomTextField!
    @IBOutlet weak var patientDescriptionField: UITextView!
    
    @IBOutlet weak var addImageBtnOne: UIButton!
    @IBOutlet weak var addImageBtnTwo: UIButton!
    
    public var userData: NSMutableDictionary?
    var currentTextField =  UITextField()
    let typesOfOrgan = ["Blood","Kidney","Heart","Lung","Lever","Eye"]
    let typeOfRelation = ["Father","Mother","Sister","Brother","Cousine","Friend","Colleague","Other"]
    let typesOfSex = ["Male","Female"]
    let typesOfBlood = ["O-","O+","A-","A+","B-","B+","AB-","AB+"]
    let pickerView = UIPickerView()
    
    var patientLatLong : CLLocationCoordinate2D? = nil
    let postData = HelpPost()
    let feedViewModel = FeedViewModel()
    let global = Singleton.sharedInstance()
    var imagePicker = UIImagePickerController()

    //MARK: - ViewController Delegate -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        currentTextField.resignFirstResponder()
        patientDescriptionField.resignFirstResponder()
    }

    override func viewWillLayoutSubviews() {
        userImage.layer.cornerRadius = (userImage.frame.size.height)/2
        userImage.clipsToBounds = true
        patientDescriptionField.layer.borderColor = UIColor.lightGray.cgColor
        patientDescriptionField.layer.borderWidth = 1.0
        patientDescriptionField.layer.cornerRadius = 7.0
        patientDescriptionField.text = "Please write something about patient"
        patientDescriptionField.textColor = UIColor.gray
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        self.title = "Post"
        guard let userInfo = userData else { return } //handle the error
        setUserDataInField(userData: userInfo)
    }
    func sendUserLocation(userLocationName userLocation: String, coordinate:CLLocationCoordinate2D) {
        print(userLocation)
        print(coordinate)
        patientLatLong = coordinate
        self.LocationTextField.text = userLocation
    }
    @objc func logoutUser() {
        postData.postUserNeed = self.needTextField.text
        postData.postUserLocation = self.LocationTextField.text
        postData.postUserLocationLat = patientLatLong?.latitude
        postData.postUserLocationLong = patientLatLong?.longitude
        postData.postUserName = self.patientNameTextField.text
        postData.postUserRelation = self.patientRelationTextField.text
        postData.postUserSex = self.patientSex.text
        if let age = self.patientAge.text {
            postData.postUserAge = Double("\(age)")
        }
        if let contact = self.patientAge.text {
            postData.postUserContact = Double("\(contact)")
        }
        postData.postUserBloodGroup = self.patientBloodGroupField.text
        postData.postUserDescription = self.patientDescriptionField.text
        postData.postUserImageOne = self.addImageBtnOne.imageView?.image
        postData.postUserImageTwo = self.addImageBtnTwo.imageView?.image
        feedViewModel.setUserPostDataInFirebase(userData: postData) { completed in
            if completed == true {
                print ("save done stop spinner")
            }
        }
    }
    func setUserDataInField(userData: NSMutableDictionary) {
        postData.postName = userData["name"] as? String
        postData.postUserEmail = userData["email"] as? String
        userName.text = userData["name"] as? String
        if let imageURL = ((userData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
            userImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "SaveLives"))
            postData.postUserImageUrl = imageURL
        }
    }
    @IBAction func imageBtnAction(_ sender: Any) {
        let btn = sender as! UIButton
        openImageGallery(button:btn)
    }
    func openImageGallery(button:UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            imagePicker.view.tag = button.tag
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: { () -> Void in
            let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            if picker.view.tag == self.addImageBtnOne.tag {
                self.addImageBtnOne.setImage(chosenImage, for: .normal)
            } else {
                self.addImageBtnTwo.setImage(chosenImage, for: .normal)
            }
        })
        
    }
    
    //MARK: - PickerView Delegate and DataSources -
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == self.needTextField {
            return typesOfOrgan.count
        }else if currentTextField == self.patientRelationTextField {
            return typeOfRelation.count
        } else if currentTextField == self.patientSex {
            return typesOfSex.count
        }else if currentTextField == self.patientBloodGroupField {
            return typesOfBlood.count
        }
        return 0
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(pickerView.tag)

        if currentTextField == self.needTextField {
            return typesOfOrgan[row]
        }else if currentTextField == self.patientRelationTextField {
            return typeOfRelation[row]
        } else if currentTextField == self.patientSex {
            return typesOfSex[row]
        } else if currentTextField == self.patientBloodGroupField {
            return typesOfBlood[row]
        }
        return nil
    }
    
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == self.needTextField {
            needTextField.text = typesOfOrgan[row]
        }else if currentTextField == self.patientRelationTextField {
            patientRelationTextField.text = typeOfRelation[row]
        } else if currentTextField == self.patientSex {
            patientSex.text = typesOfSex[row]
        } else if currentTextField == self.patientBloodGroupField {
            patientBloodGroupField.text = typesOfBlood[row]
        }
    }
    //MARK: - TextField Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty {
            textView.textColor = UIColor.black
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 200;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        
        let labelTexts = ["Organs","Relation","Sex","Blood Group"]
        let label: UILabel = UILabel.init(frame: CGRect(x: 0, y: 5, width: self.view.frame.width, height: 40))
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        label.backgroundColor = UIColor.lightGray
        label.textAlignment = .center
        pickerView.addSubview(label)

        if currentTextField == self.needTextField {
            label.text = labelTexts[0]
            currentTextField.inputView = pickerView
        }else if currentTextField == self.patientRelationTextField {
            label.text = labelTexts[1]
            currentTextField.inputView = pickerView
        } else if currentTextField == self.patientSex {
            label.text = labelTexts[2]
            currentTextField.inputView = pickerView
        } else if currentTextField == self.patientBloodGroupField {
            label.text = labelTexts[3]
            currentTextField.inputView = pickerView
        } else if currentTextField == self.LocationTextField {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                self.global.showProgessBar()
                let viewcontroller : LocationSearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearchViewController
                viewcontroller.delegate = self
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.patientAge {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newText.count < 3;
        }
        return true
    }

}

