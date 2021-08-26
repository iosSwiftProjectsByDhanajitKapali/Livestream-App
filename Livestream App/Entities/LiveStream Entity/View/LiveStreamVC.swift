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

    //MARK: - Private Variables
    private var presenter : Presenter!
    
    
    //MARK: - Public Variables
    var tableViewData = [LiveCommentModel]()
    
    //Variables for AgoraRTC
    var agoraRtcKit: AgoraRtcEngineKit?

    //variables used for AgoraRTM
    var kit : AgoraRtmKit?
    var channel : AgoraRtmChannel?
    var agoraRtmUserID : String?
   
    var liveStreamHostAudioStatus : LiveStreamHostAudioStatus = .audioIsOn
    var liveStreamHostVideoStatus : LiveStreamHostVideoStatus = .videoIsOn

    
    //MARK: - IBOutlets
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
    @IBOutlet var leaveLivestreamButton: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func leaveLivestreamButtonPressed(_ sender: UIButton) {
        
        //presentCustomAlert()
        presentBottomSheet()
    }
    
    @IBAction func sendCommentButtonPressed(_ sender: UIButton) {
        if let message = addCommentTextField.text, !message.isEmpty{
            sendGroupMessage(withMessageText: message)
            addCommentTextField.text = ""
        }
    }
    
    @IBAction func goToLatestLiveCommentButtonPressed(_ sender: UIButton) {
        scrollToFirstRow()
    }
    
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        //Start the Animation
        (0...4).forEach { _ in
            generateHeartBubblesAnimation(onView: heartBubbleBackgroundView)
        }
    }
    
    
}


//MARK: - LifeCycle Methods
extension LiveStreamVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDesignToUI()
        initialSetup()
        
        //Setup the Presenter
        presenter = Presenter(withDelegate: self)
        
        //start the liveStream
        startLiveStream()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        disposeAgora()
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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


//MARK: - CustomAlertDelegate Functions
extension LiveStreamVC : CustomAlertDelegate{
    func alertButtonPressed(atIndex: Int) {
        if atIndex == 1 {
            stopliveStream()
            navigationController?.popViewController(animated: true)
        }else{
            if let viewWithTag = self.view.viewWithTag(1){
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
}


//MARK: - Public Methods
extension LiveStreamVC{
    func presentCustomAlert(){
        //loading the XIB into our view
        let alertData = CustomAlertModel(alertTitle: "Are You Sure ?", alertMessage: "You want to leave the livestream", alertButtonOneTitle: "Yes", alertButtonTwoTitle: "No")
        let customAlertView = CustomAlert(frame: self.view.bounds, data: alertData)
        customAlertView.delegate = self
        customAlertView.tag = 1
        self.view.addSubview(customAlertView)
    }
}


//MARK: - Private functions
private extension LiveStreamVC{
    
    func addDesignToUI(){
        navigationController?.navigationBar.barTintColor = UIColor.black
        remoteView.layer.cornerRadius = 10
        self.addCommentTextField.layer.cornerRadius = 20
        self.addCommentTextField.layer.borderWidth = 2.0
        self.addCommentTextField.layer.borderColor = UIColor.gray.cgColor
        addCommentTextField.setLeftPaddingPoints(10)
        
        hostProfileImageView.makeImageCircular()
        
    }
    
    func initialSetup(){
        //Call methods defined in BaseVC to design navigation bar.
        //Other initializations
        
        goToLatestCommentButton.isHidden = true
        
        //hide the leave button
        //self.leaveLiveStreamButton.isEnabled = false
        
        addCommentTextField.delegate = self
        
        //register the tableViewCell
        liveCommentsTableView.isHidden = true
        liveCommentsTableView.dataSource = self
        liveCommentsTableView.delegate = self
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
    
    func startLiveStream(){
        //join the Agora RTC
        joinAgoraRtcChannel()
        //login and join the Agora RTM
        loginToAgoraRTMServer(withUserID: "userA")
    }
    
    func stopliveStream() {
        leaveAgoraRtcChannel()
        leaveAoraRtmChannel()
    }
    
    func disposeAgora(){
        //release the resources after
        AgoraRtcEngineKit.destroy()
        
        //leave the LiveMessageChannel
        //kit?.destroyChannel(withId: Constant.AgoraKeys.AGORA_RTM_CHANNEL_NAME)
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.liveCommentsTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    /*
     Example code, on how to use functions from presenter
     */
    func getData(){
        LoaderUtility.shared.showLoader(onView: self.view)
        presenter.getData()
    }
   
}








