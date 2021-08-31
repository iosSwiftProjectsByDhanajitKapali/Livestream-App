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
import Alamofire

class LiveStreamVC: BaseVC {

    //MARK: - Private Variables
    private var presenter : Presenter!
    var heartBubbleTotalCount : Int = 0
    
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
    
    @IBOutlet var newMemberJoinedBackgroundView: UIView!
    @IBOutlet var newMemberJoinedUserNameTextLabel: UILabel!
    @IBOutlet var addCommentBackgroundView: UIView!
    @IBOutlet var addCommentTextField: UITextField!
    @IBOutlet var sendCommentButton: UIButton!
    @IBOutlet var liveCommentsTableView: UITableView!
    @IBOutlet var heartBubbleBackgroundView: UIView!
    @IBOutlet var heartBubbleTotalCountTextLabel: UILabel!
    @IBOutlet var goToLatestCommentButton: UIButton!
    @IBOutlet var remoteView: UIView!
    @IBOutlet var leaveLivestreamButton: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func leaveLivestreamButtonPressed(_ sender: UIButton) {
        
        //presentCustomAlert()
        presentBottomSheet()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print("Shared button Pressed")
    }
    
    @IBAction func sendCommentButtonPressed(_ sender: UIButton) {
        if let message = addCommentTextField.text, !message.isEmpty{
            if validateComment(commentText: message) {
                sendGroupMessage(withMessageText: message)
                addCommentTextField.text = ""
            }
        }
    }
    
    @IBAction func goToLatestLiveCommentButtonPressed(_ sender: UIButton) {
        scrollToFirstRow()
    }
    
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        heartBubbleTotalCount+=1
        heartBubbleTotalCountTextLabel.text = String(heartBubbleTotalCount)
        
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        getTokens()
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
    func presentCustomAlert(withTitle: String, message: String, buttonOneTitle: String, buttonTwoTitle:String){
        //loading the XIB into our view
        let alertData = CustomAlertModel(alertTitle: withTitle, alertMessage: message, alertButtonOneTitle: buttonOneTitle, alertButtonTwoTitle: buttonTwoTitle)
        let customAlertView = CustomAlert(frame: self.view.bounds, data: alertData)
        customAlertView.delegate = self
        customAlertView.tag = 1
        self.view.addSubview(customAlertView)
    }
    
    func validateComment(commentText : String) -> Bool{
        if !commentText.isEmailFormatted() && !commentText.isValidMobileNo(){
            return true
        }else{
            return false
        }
    }
}


//MARK: - Private functions
private extension LiveStreamVC{
    
    func addDesignToUI(){
        navigationController?.navigationBar.barTintColor = UIColor.black
        remoteView.layer.cornerRadius = 10
        
        self.newMemberJoinedBackgroundView.layer.cornerRadius = 15
        self.newMemberJoinedBackgroundView.layer.borderWidth = 3
        self.newMemberJoinedBackgroundView.layer.borderColor = UIColor.white.cgColor
        self.newMemberJoinedBackgroundView.isHidden = true

        self.addCommentTextField.layer.cornerRadius = 20
        self.addCommentBackgroundView.layer.cornerRadius = 20
        
        addCommentTextField.setLeftPaddingPoints(5)
        
        hostProfileImageView.makeImageCircular()
        
    }
    
    func initialSetup(){
        //Call methods defined in BaseVC to design navigation bar.
        //Other initializations
        
        SceneDelegate.delegate = self
        
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
        
        heartBubbleTotalCountTextLabel.text = String(heartBubbleTotalCount)
        
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
    
    func getTokens(){
        let headers : HTTPHeaders = [
                "Authorization": "Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJVc2VyVHlwZSI6IkFzdHJvbG9nZXIiLCJFbnRpdHlJZCI6IjEwOTYiLCJTb3VyY2VVc2VyVHlwZSI6IiIsIlNvdXJjZUVudGl0eUlkIjoiIiwibmJmIjoxNjI5OTgzMTg0LCJleHAiOjE2MzA1ODc5ODR9.",
                "Accept-Language": "US"
            ]
        
        NetworkManager().getAPICall(url: "https://chdemo.astroyogi.com/api/AstrologerLiveStream/GetAgoraAccessToken", parameters: [:], headers: headers, responseClass: MyTokenModel.self) { [self] result  in
            switch result{
            case .success(let theData):
                Constant.AgoraKeys.AGORA_RTC_TEMP_TOKEN = theData.data.voiceAccessToken
                Constant.AgoraKeys.AGORA_RTM_TEMP_TOKEN = theData.data.accessToken
                Constant.AgoraKeys.AGORA_RTC_CHANNEL_NAME = theData.data.channelName
                Constant.AgoraKeys.AGORA_RTM_CHANNEL_NAME = theData.data.channelName
                
                //start the liveStream
                startLiveStream()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /*
     Example code, on how to use functions from presenter
     */
    func getData(){
        LoaderUtility.shared.showLoader(onView: self.view)
        presenter.getData()
    }
   
}








