//
//  LoginVC.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 04/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {

    private var presenter : LoginVCPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup the Presenter
        presenter = LoginVCPresenter(withDelegate: self)
    }
    
    func initialSetup(){
        //Call methods defined in BaseVC to design navigation bar.
        //Other initializations
    }
    
    func getData(){
        LoaderUtility.shared.showLoader(onView: self.view)
        presenter.getData()
    }
}

extension LoginVC : LoginVCPresenterDelegate{
    func didRecieveResponse(dataModel: MyModel) {
        //Process the Response
    }
    
    func didRecieveFailedRepsonse(errorMessage: String) {
        //Process the errorMessage
    }
    
    
}
