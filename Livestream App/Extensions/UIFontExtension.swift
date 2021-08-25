//
//  UIFontExtension.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 25/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: - Methods to get Custom fonts
extension UIFont{
    
    static func openSansRegular(withTheFontSize : CGFloat) -> UIFont{
        return UIFont(name: "OpenSans-Regular", size: withTheFontSize) ?? .systemFont(ofSize: withTheFontSize)
    }
    
    static func openSansBold(withTheFontSize : CGFloat) -> UIFont{
        return UIFont(name: "OpenSans-Bold", size: withTheFontSize) ?? .systemFont(ofSize: withTheFontSize)
    }
}
        
