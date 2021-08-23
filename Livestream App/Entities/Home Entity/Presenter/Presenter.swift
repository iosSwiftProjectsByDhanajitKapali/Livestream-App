//
//  Presenter.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol PresenterDelegate : AnyObject {
    func didRecieveResponse(dataModel : MyModel)
    func didRecieveFailedRepsonse(errorMessage : String)
}

class Presenter {
    
    weak var delegate : PresenterDelegate?
    
    private var BaseUrl : String?
    
    init(withDelegate delegate : PresenterDelegate) {
        self.delegate  = delegate
    }
    
}

//MARK: - Api call
extension Presenter{
    
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
