//
//  ViewController.swift
//  daffo-ios-base
//
//  Created by Sujeet Shrivastav on 14/08/20.
//  Copyright © 2020 Daffodil Software Pvt. Ltd. All rights reserved.
//

/*

 Step 1 - Rename the project
 Click on the project you want to rename in the "Project navigator" in the left panel of the Xcode window.
 In the right panel, select the "File inspector", and the name of your project should be found under "Identity and Type". Change it to your new name.
 When the dialog asks whether to rename or not rename the project's content items, click "Rename". Say yes to any warning about uncommitted changes.
 Step 2 - Rename the scheme
 At the top of the window, next to the "Stop" button, there is a scheme for your product under its old name; click on it, then choose "Manage Schemes…".
 Click on the old name in the scheme and it will become editable; change the name and click "Close".
 Step 3 - Rename the folder with your assets
 Quit Xcode. Rename the master folder that contains all your project files.
 In the correctly-named master folder, beside your newly-named .xcodeproj file, there is probably a wrongly-named OLD folder containing your source files. Rename the OLD folder to your new name (if you use Git, you could run git mv oldname newname so that Git recognizes this is a move, rather than deleting/adding new files).
 Re-open the project in Xcode. If you see a warning "The folder OLD does not exist", dismiss the warning. The source files in the renamed folder will be grayed out because the path has broken.
 In the "Project navigator" in the left-hand panel, click on the top-level folder representing the OLD folder you renamed.
 In the right-hand panel, under "Identity and Type", change the "Name" field from the OLD name to the new name.
 Just below that field is a "Location" menu. If the full path has not corrected itself, click on the nearby folder icon and choose the renamed folder.
 Step 4 - Rename the Build plist data
 Click on the project in the "Project navigator" on the left, and in the main panel select "Build Settings".
 Search for "plist" in the settings.
 In the Packaging section, you will see Info.plist and Product Bundle Identifier.
 If there is a name entered in Info.plist, update it.
 Do the same for Product Bundle Identifier, unless it is utilizing the ${PRODUCT_NAME} variable. In that case, search for "product" in the settings and update Product Name. If Product Name is based on ${TARGET_NAME}, click on the actual target item in the TARGETS list on the left of the settings pane and edit it, and all related settings will update immediately.
 Search the settings for "prefix" and ensure that Prefix Header's path is also updated to the new name.
 If you use SwiftUI, search for "Development Assets" and update the path.
 Step 5 - Repeat step 3 for tests (if you have them)
 Step 6 - Repeat step 3 for core data if its name matches project name (if you have it)
 Step 7 - Clean and rebuild your project
 Command + Shift + K to clean
 Command + B to build

 */


import UIKit
import AgoraRtcKit
import AgoraRtmKit

class ViewController: BaseVC {

    //MARK: - All IBOutlets
    @IBOutlet var addCommentTextField: UITextField!
    @IBOutlet var sendCommentButton: UIButton!
    @IBOutlet var liveCommentsTableView: UITableView!
    @IBOutlet var heartBubbleBackgroundView: UIView!
    @IBOutlet var remoteView: UIView!
    @IBOutlet var joinLiveStreamButton: UIBarButtonItem!
    @IBOutlet var leaveLiveStreamButton: UIBarButtonItem!
    
    //MARK: - Variables Used in ViewController
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
extension ViewController{
    
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
extension ViewController : PresenterDelegate{
    func didRecieveResponse(dataModel: MyModel) {
        //Process The Recived data
    }
    
    func didRecieveFailedRepsonse(errorMessage : String) {
        //Process the Error
    }
}

//MARK: - Private functions
private extension ViewController{
    
    func initialSetup(){
        //Call methods defined in BaseVC to design navigation bar.
        //Other initializations
        navigationController?.navigationBar.barTintColor = UIColor.black
        remoteView.layer.cornerRadius = 10
        self.addCommentTextField.layer.cornerRadius = 20
        self.addCommentTextField.layer.borderWidth = 2.0
        self.addCommentTextField.layer.borderColor = UIColor.gray.cgColor
        addCommentTextField.setLeftPaddingPoints(10)
        
        //hide the leave button
        self.leaveLiveStreamButton.isEnabled = false
        
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




