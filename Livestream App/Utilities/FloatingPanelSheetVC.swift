//
//  FloatingPanelSheetVC.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 26/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

protocol FloatingPanelSheetVCDelegate {
    func floatingPanelSheetButtonPressed(atIndex : Int)
}

class FloatingPanelSheetVC: UIViewController {
    
    private var buttonArray = [FloatingPanelSheetButtonModel]()
    
    var delegate : FloatingPanelSheetVCDelegate?
    
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }

}

extension FloatingPanelSheetVC{
    func addNewButton(newButton : FloatingPanelSheetButtonModel){
        buttonArray.append(newButton)
        myTableView.reloadData()
    }
}

extension FloatingPanelSheetVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buttonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named:buttonArray[indexPath.row].imageName)
        cell.textLabel?.text = buttonArray[indexPath.row].buttonTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.floatingPanelSheetButtonPressed(atIndex: indexPath.row)
    }
    
}

struct FloatingPanelSheetButtonModel{
    let imageName : String
    let buttonTitle : String
}
