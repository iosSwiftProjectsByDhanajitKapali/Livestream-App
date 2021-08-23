//
//  LoginVC_Presenter.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 04/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol LoginVCPresenterDelegate : AnyObject {
    func didRecieveResponse(dataModel : MyModel)
    func didRecieveFailedRepsonse(errorMessage : String)
}

class LoginVCPresenter {
    
    weak var delegate : LoginVCPresenterDelegate?
    
    private var BaseUrl : String?
    
    init(withDelegate delegate : LoginVCPresenterDelegate) {
        self.delegate  = delegate
    }
    
}

//MARK: - Api call
extension LoginVCPresenter{
    
    public func getData(){
        BaseUrl = ""
        let params : [String:Any] = [:]
        NetworkManager().getAPICall(url: BaseUrl!, parameters: params, headers: [:], responseClass: MyModel.self) { (result) in
            switch result{
            case .success(let data):
                self.delegate?.didRecieveResponse(dataModel: data)
            case .failure(let error):
                self.delegate?.didRecieveFailedRepsonse(errorMessage : error.localizedDescription)
            }
        }
    }
}
