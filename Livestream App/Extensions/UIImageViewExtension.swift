//
//  UIImageViewExtension.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 29/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIImageView{
    
    ///Make the ImageView Circular
    func makeImageCircular(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2.0
    }
}
