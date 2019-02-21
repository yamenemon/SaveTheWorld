//
//  CustomTextField.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 21/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import Foundation
import UIKit

class MyCustomTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.white
    }
    
    
}
