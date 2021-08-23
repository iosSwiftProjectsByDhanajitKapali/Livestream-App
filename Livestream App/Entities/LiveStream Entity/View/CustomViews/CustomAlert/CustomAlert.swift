//
//  CustomAlert.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 23/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CustomAlert: UIView {

    //MARK: - IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet var alertTitle: UILabel!
    @IBOutlet var alertMessage: UILabel!
    @IBOutlet var alertButtonOne: UIButton!
    @IBOutlet var alertButtonTwo: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func alertButtonOnePressed(_ sender: UIButton) {
        print("Button One Pressed")
    }
    
    @IBAction func alertButtonTwoPressed(_ sender: UIButton) {
        print("Button two pressed")
    }
    
    //Boilerplate to load xib
    init(frame: CGRect, data : CustomAlertModel) {
        super.init(frame: frame)
        loadViewFromNib()
        
        //Do the initial setup, and populate the alert with your custom data
        initialSetup()
        populatePopUp(customAlertData: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    private func loadViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    } //:BoilerPlate ends
    
    
    private func initialSetup() {
        containerView.layer.cornerRadius = 20
        
    }
    
    private func populatePopUp(customAlertData : CustomAlertModel){
        alertTitle.text = customAlertData.alertTitle
        alertMessage.text = customAlertData.alertMessage
        alertButtonOne.setTitle(customAlertData.alertButtonOneTitle, for: .normal)
        alertButtonTwo.setTitle(customAlertData.alertButtonTwoTitle, for: .normal)
    }

}

struct CustomAlertModel{
    let alertTitle : String
    let alertMessage : String
    let alertButtonOneTitle : String
    let alertButtonTwoTitle : String
}



