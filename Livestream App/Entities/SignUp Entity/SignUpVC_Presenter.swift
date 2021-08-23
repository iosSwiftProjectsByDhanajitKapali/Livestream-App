//
//  SignUpVC_Presenter.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 04/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol SignUpVCPresenterDelegate : AnyObject {
    func didRecieveResponse(dataModel : MyModel)
    func didRecieveFailedRepsonse(errorMessage : String)
}

class SignUpVCPresenter {
    
    weak var delegate : SignUpVCPresenterDelegate?
    
    private var BaseUrl : String?
    
    init(withDelegate delegate : SignUpVCPresenterDelegate) {
        self.delegate  = delegate
    }
    
}

//MARK: - Api call
extension SignUpVCPresenter{
    
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
