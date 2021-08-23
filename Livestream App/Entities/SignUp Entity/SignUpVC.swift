//
//  SignUpVC.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 04/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class SignUpVC: BaseVC {

    private var presenter : SignUpVCPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup the Presenter
        presenter = SignUpVCPresenter(withDelegate: self)
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

extension SignUpVC : SignUpVCPresenterDelegate{
    func didRecieveResponse(dataModel: MyModel) {
        //Process The Recieved Data
    }
    
    func didRecieveFailedRepsonse(errorMessage: String) {
        //Process the errorMessage
    }
    
    
}
