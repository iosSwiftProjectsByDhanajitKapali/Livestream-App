//
//  loaderUtility.swift
//  ACT_Login_Demo
//
//  Created by daffolapmac-92 on 28/01/21.
//  Copyright © 2021 Unthinkable Solutions. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class LoaderUtility {

    // MARK: - Singleton instance
    static var shared: LoaderUtility = LoaderUtility()

    /// Use this Method to show loader
    func showLoader(onView view: UIView) {
        let Indicator = MBProgressHUD.showAdded(to:view, animated: true)
        Indicator.isUserInteractionEnabled = false
        Indicator.show(animated: true)
    }

    /// Use this Method to hide loader
    func hideLoader(fromView view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
