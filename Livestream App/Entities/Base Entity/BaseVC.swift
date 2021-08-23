//
//  BaseVC.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var rightNavBarButton : UIBarButtonItem? = nil
    var leftNavBarButton : UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

}

//MARK: - Customize the Navigation Bar
extension BaseVC{
    public func setNavBarBackgroundColor(withColor : UIColor){
        self.navigationController?.navigationBar.barTintColor = withColor
    }

    public func setNavBarTitle(withTitle: String){
        self.navigationItem.title = withTitle
    }
    
    public func setNavBarTitleColor(withColor: UIColor){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: withColor]
    }
    
    public func setNavBarRightButton(withButton: UIBarButtonItem){
        rightNavBarButton = withButton
        self.navigationItem.rightBarButtonItem = withButton
    }
    
    public func setNavBarLeftButton(withButton: UIBarButtonItem){
        leftNavBarButton = withButton
        self.navigationItem.leftBarButtonItem = withButton
    }
    
    public func hideNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func unHideNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public func hideNavBarLeftButton(){
        self.navigationItem.leftBarButtonItem = nil
    }
    
    public func unHideNavBarLeftButton(){
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    public func hideNavBarRightButton(){
        self.navigationItem.rightBarButtonItem = nil
    }
    
    public func unHideNavBarRightButton(){
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
}



