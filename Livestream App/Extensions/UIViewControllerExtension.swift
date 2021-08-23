//
//  UIViewControllerExtension.swift
//  RealmDemo
//
//  Created by unthinkable-mac-0025 on 24/07/21.
//

import Foundation
import UIKit

extension UIViewController{
    
    ///Display an alert
    func displayAlert(alertMessage:String){
        let alert = UIAlertController(title: Constant.TextMessage.ALERT, message: alertMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: Constant.TextMessage.OK, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    ///Display an alert , Pressing "Ok" button will pop the current view
    func displayAlertAndPopView(alertMessage:String){
        let alert = UIAlertController(title: Constant.TextMessage.ALERT, message: alertMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: Constant.TextMessage.OK , style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    ///Display an error alert
    func displayErrorAlert(){
        let errorAlert = UIAlertController(title: Constant.TextMessage.ALERT, message: Constant.ErrorMessage.SOMETHING_WENT_WRONG, preferredStyle: .alert)

        let okAction = UIAlertAction(title: Constant.TextMessage.OK , style: .default, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true)
    }
    
    //Jump to a Scene in StoryBoard, if current Scene is embedded in a NavigationController
    func goToScreen(withIdentifier identifier: String,
                    storyboardId: String? = nil,
                    modally: Bool = false,
                    viewControllerConfigurationBlock: ((UIViewController) -> Void)? = nil) {
      var storyboard = self.storyboard
      
      if let storyboardId = storyboardId {
        storyboard = UIStoryboard(name: storyboardId, bundle: nil)
      }
      
      guard let viewController =
        storyboard?.instantiateViewController(withIdentifier: identifier) else {
        assert(false, Constant.ErrorMessage.NO_VIEW_CONTROLLER_FOUND_FOR_THIS_IDENTIFIER)
          return
      }
      
      viewControllerConfigurationBlock?(viewController)
      
      if modally {
        present(viewController, animated: true)
      } else {
        assert(navigationController != nil, Constant.ErrorMessage.NAVIGATION_CONTROLLER_IS_NIL)
        navigationController?.pushViewController(viewController, animated: true)
      }
    }
    
    ///Hide the keyboard from View
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    ///Show a toast message
    func showToast(message : String, font: UIFont, toastColor: UIColor = UIColor.white,
                       toastBackground: UIColor = UIColor.black) {
            let toastLabel = UILabel()
            toastLabel.textColor = toastColor
            toastLabel.font = font
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.alpha = 0.0
            toastLabel.layer.cornerRadius = 6
            toastLabel.backgroundColor = toastBackground

            toastLabel.clipsToBounds  =  true

            let toastWidth: CGFloat = toastLabel.intrinsicContentSize.width + 16
            let toastHeight: CGFloat = 32
            
            toastLabel.frame = CGRect(x: self.view.frame.width / 2 - (toastWidth / 2),
                                      y: self.view.frame.height - (toastHeight * 3),
                                      width: toastWidth, height: toastHeight)
            
            self.view.addSubview(toastLabel)
            
            UIView.animate(withDuration: 1.5, delay: 0.25, options: .autoreverse, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
}
