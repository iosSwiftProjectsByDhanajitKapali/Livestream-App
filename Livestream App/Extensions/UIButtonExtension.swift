//
//  UIButtonExtension.swift
//  daffo-ios-base
//
//  Created by Sujeet Shrivastav on 14/08/20.
//  Copyright © 2020 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIButton {
      
    ///Add  a SFSymbol to the Button
    ///
    /// - Parameter iconName : SFSymbol Name
    /// - Parameter size : Size of the Symbol in points
    /// - Parameter scale : .small, .medium, .large
    /// - Parameter weight : .ultralight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
    /// - Parameter tintColor : Color of the Symbol
    /// - Parameter backgroundColor : Background color of the button
    ///
    func setSFSymbol(iconName: String, size: CGFloat, weight: UIImage.SymbolWeight,
                       scale: UIImage.SymbolScale, tintColor: UIColor, backgroundColor: UIColor) {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        let buttonImage = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        self.setImage(buttonImage, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
}

extension UIButton {
    ///Use this Function to add padding between the Image and the Title of the Added SF Symbol
    ///
    /// - Parameter padding: - the spacing between the Image and the Title of the Added SF Symbol
    func centerTitleVertically(padding: CGFloat = 12.0) {
        guard let imageViewSize = self.imageView?.frame.size, let titleLabelSize = self.titleLabel?.frame.size
            else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height) / 2,
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}
