//
//  ViewController.swift
//  daffo-ios-base
//
//  Created by Sujeet Shrivastav on 14/08/20.
//  Copyright © 2020 Daffodil Software Pvt. Ltd. All rights reserved.
//


import UIKit
import AgoraRtcKit
import AgoraRtmKit

class LiveStreamVC: BaseVC {

    //MARK: - All IBOutlets
    @IBOutlet var hostProfileImageView: UIImageView!
    @IBOutlet var hostUserNameTextLabel: UILabel!
    @IBOutlet var isHostLiveTextLabel: UILabel!
    @IBOutlet var livestreamUptimeTextLabel: UILabel!
    @IBOutlet var activePeopleInLivestreamTextLabel: UILabel!
    
    @IBOutlet var addCommentTextField: UITextField!
    @IBOutlet var sendCommentButton: UIButton!
    @IBOutlet var liveCommentsTableView: UITableView!
    @IBOutlet var heartBubbleBackgroundView: UIView!
    @IBOutlet var goToLatestCommentButton: UIButton!
    @IBOutlet var remoteView: UIView!
    @IBOutlet var joinLiveStreamButton: UIBarButtonItem!
    @IBOutlet var leaveLiveStreamButton: UIBarButtonItem!
    
    //MARK: - Variables Used in LiveStreamVC
    private var presenter : Presenter!
    var tableViewData = [LiveCommentModel]()
    
    
    //Variables for AgoraRTC
    var agoraKit: AgoraRtcEngineKit?

    
    //variables used for AgoraRTM
    var kit : AgoraRtmKit?
    var channel : AgoraRtmChannel?
    
    var agoraRtmUserID : String?
   

    
    //MARK: - ALL IBActions
    @IBAction func joinButtonPressed(_ sender: UIBarButtonItem) {
        print("Join Button Pressed")
        joinAgoraRtcChannel()
        
        //login and join the Agora RTM
        loginToAgoraRTMServer(withUserID: "userA")
        
        joinLiveStreamButton.isEnabled = false
        leaveLiveStreamButton.isEnabled = true
    }
    
    @IBAction func leaveButtonPressed(_ sender: UIBarButtonItem) {
        print("Leave Button Presses")
        leaveAgoraRtcChannel()
        leaveAoraRtmChannel()
        
        joinLiveStreamButton.isEnabled = true
        leaveLiveStreamButton.isEnabled = false
    }
    
    @IBAction func sendCommentButtonPressed(_ sender: UIButton) {
        if let message = addCommentTextField.text, !message.isEmpty{
            sendGroupMessage(withMessageText: message)
            addCommentTextField.text = ""
        }
    }
    
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        print("heart button pressed")
        
        let frame = CGRect(x: 240, y: 500, width: 160, height: 280)
        let curvedView = CurvedView(frame: frame)
        curvedView.backgroundColor = .clear
        heartBubbleBackgroundView.addSubview(curvedView)
        
        (0...4).forEach { _ in
            generateHeartBubblesAnimation(onView: heartBubbleBackgroundView)
        }
    }
    
    
}

//MARK: - LifeCycle Methods
extension LiveStreamVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        //Setup the Presenter
        presenter = Presenter(withDelegate: self)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //release the resources after
        AgoraRtcEngineKit.destroy()
        
        //leave the LiveMessageChannel
        leaveAoraRtmChannel()
    }
}


//MARK: - Presenter delegate methods
extension LiveStreamVC : PresenterDelegate{
    func didRecieveResponse(dataModel: MyModel) {
        //Process The Recived data
    }
    
    func didRecieveFailedRepsonse(errorMessage : String) {
        //Process the Error
    }
}

//MARK: - Private functions
private extension LiveStreamVC{
    
    func initialSetup(){
        //Call methods defined in BaseVC to design navigation bar.
        //Other initializations
        navigationController?.navigationBar.barTintColor = UIColor.black
        remoteView.layer.cornerRadius = 10
        self.addCommentTextField.layer.cornerRadius = 20
        self.addCommentTextField.layer.borderWidth = 2.0
        self.addCommentTextField.layer.borderColor = UIColor.gray.cgColor
        addCommentTextField.setLeftPaddingPoints(10)
        
        hostProfileImageView.makeImageCircular()
        goToLatestCommentButton.isHidden = true
        
        //hide the leave button
        //self.leaveLiveStreamButton.isEnabled = false
        
        addCommentTextField.delegate = self
        
        //register the tableViewCell
        liveCommentsTableView.dataSource = self
        liveCommentsTableView.register(UINib(nibName: "LiveCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveCommentsTableViewCellID")
        liveCommentsTableView.transform = CGAffineTransform (scaleX: -1,y: -1);
        
        
        //setup the AGORA RTC
        // This function initializes the local and remote video views
        //initView()
        // The following functions are used when calling Agora APIs
        initializeAgoraEngine()
        setChannelProfile()
        setClientRole()
        //setupLocalVideo()
        
        //setup the agoraRTM
        kit = AgoraRtmKit(appId: Constant.AgoraKeys.AGORA_RTM_APP_ID, delegate: self)
    }
    
    
    /*
     Example code, on how to use functions from presenter
     */
    func getData(){
        LoaderUtility.shared.showLoader(onView: self.view)
        presenter.getData()
    }
   
}




