//
//  ViewControllerExtensionForUITextField.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 21/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension ViewController : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
   }

}
