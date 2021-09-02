//
//  ViewControllerExtensionForUITextField.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 21/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension LiveStreamVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        likeButtonStackView.isHidden = true
        sendCommentButton.isHidden = true
        shareButton.isHidden = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason){
        likeButtonStackView.isHidden = false
        sendCommentButton.isHidden = false
        shareButton.isHidden = true
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
