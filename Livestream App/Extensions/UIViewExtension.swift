//
//  UIViewExtension.swift
//  daffo-ios-base
//
//  Created by Sujeet Shrivastav on 14/08/20.
//  Copyright © 2020 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIView{
    
    //Change the default values for params as you wish
    func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
      layer.borderColor = color.cgColor
      layer.borderWidth = weight
    }
    
    func setRoundBorders(_ cornerRadius: CGFloat = 10.0) {
      clipsToBounds = true
      layer.cornerRadius = cornerRadius
    }
    
    var typeName: String {
      return String(describing: type(of: self))
    }
    
    func instanceFromNib(withName name: String) -> UIView? {
      return UINib(nibName: name,
                   bundle: nil).instantiate(withOwner: self,
                                            options: nil).first as? UIView
    }
    
    func addNibView(withNibName nibName: String? = nil, withAutoresizingMasks masks: AutoresizingMask = [.flexibleWidth, .flexibleHeight]) -> UIView {
        
      let name = String(describing: type(of: self))
      guard let view = instanceFromNib(withName: nibName ?? name) else {
        assert(false, Constant.ErrorMessage.NO_NIB_FOUND_WITH_THHIS_NAME)
          return UIView()
      }
      view.frame = bounds
      view.autoresizingMask = masks
      addSubview(view)
      return view
    }
    
    func animateChangeInLayout(withDuration duration: TimeInterval = 0.2) {
      setNeedsLayout()
      UIView.animate(withDuration: duration, animations: { [weak self] in
        self?.layoutIfNeeded()
      })
    }
    
   
}
