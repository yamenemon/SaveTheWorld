//
//  HelpPopUpViewController.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 20/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit

class HelpPopUpViewController: UIViewController {

    public var userData: NSMutableDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        print(userData as Any)
        if let userDataDic = userData {
            print(userDataDic)
        }
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        self.title = "Post Description"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
