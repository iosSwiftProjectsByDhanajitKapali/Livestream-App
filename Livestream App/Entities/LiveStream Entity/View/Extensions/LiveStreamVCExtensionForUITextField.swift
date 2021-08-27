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
        
        let message = addCommentTextField.text
        if !message.isEmptyOrWhitespace(){
            if let message = message{
                if validateComment(commentText: message){
                    sendGroupMessage(withMessageText: message)
                    addCommentTextField.text = ""
                }else{
                    displayAlert(alertMessage: "Not allowed to send Phone no. or Email-ID")
                    addCommentTextField.text = ""
                }
            }
        }else{
            addCommentTextField.text = ""
        }        
        return true
    }
    
}
