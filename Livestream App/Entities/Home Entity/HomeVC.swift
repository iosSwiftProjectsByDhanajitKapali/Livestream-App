//
//  HomeViewController.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 23/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit
import TransitionButton

class HomeVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var joinLivestreamButton: TransitionButton!
    
    
    //MARK: - IBActions
    @IBAction func joinLivestreamButtonPressed(_ button: TransitionButton) {
        button.startAnimation() // start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            sleep(2) // Do your networking task or background work here.

            DispatchQueue.main.async(execute: { () -> Void in
                button.backgroundColor = .black
                button.stopAnimation(animationStyle: .expand, completion: {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryBoardSceneID.LIVE_STREAM_SCREEN_ID) as! LiveStreamVC
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            })
        })
    }
    
    

}

//MARK: - Lifecyle methods of HomeVC
extension HomeVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        addDesignToUI()
    }
}

private extension HomeVC{
    func initialSetup(){
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    func addDesignToUI(){
        joinLivestreamButton.backgroundColor = .systemPink
        joinLivestreamButton.layer.cornerRadius = 20
        
       
    }
}
