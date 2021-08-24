//
//  ViewControllerExtensionForUITextField.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 21/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension LiveStreamVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    //defining the task to be done when the return(Go) key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)    //ending the editing ,collapse keyboard
        if let message = addCommentTextField.text, !message.isEmpty{
            sendGroupMessage(withMessageText: message)
            addCommentTextField.text = ""
        }
        return true
    }
    
}
