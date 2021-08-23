//
//  ViewControllerExtensionForAgoraRTM.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 20/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation
import AgoraRtmKit


extension LiveStreamVC{
    
    ///Add new Message to the LiveComments TableView
    func appendMessage(user: String, content: String) {
        DispatchQueue.main.async { [unowned self] in
            let newComment = LiveCommentModel(userName: user, userComment: content)
            addNewLiveCommentInTableView(comment: newComment)
        }
    }
    
}

//MARK: - Agora RTM service Manager
extension LiveStreamVC{
    
    ///Login to the RTM system
    func loginToAgoraRTMServer(withUserID : String){
        self.agoraRtmUserID = withUserID
        //let token = Constant.AgoraKeys.AGORA_RTM_TEMP_TOKEN
        kit?.login(byToken: nil, user: withUserID, completion: { [self] (errorCode) in
        
            if errorCode == AgoraRtmLoginErrorCode.ok{
                self.joinAgoraRtmChannel(withChannelID: self.agoraRtmUserID!)
                print("Login Successful")
            }else{
                displayAlert(alertMessage: "Failed to Login to RTM server")
            }
        })
    }
    
    ///Logout the RTM system
    func logoutFromAgoraRTMServer(){
        kit?.logout(completion: { [self] (errorCode) in
            if errorCode == AgoraRtmLogoutErrorCode.ok{
                print("Logout Succesful for user \(String(describing: self.agoraRtmUserID)). Code: \(errorCode)")
            }else{
                displayAlert(alertMessage: "Failed to Logout")
                print("Logout Failed")
            }
        })
    }
    
    ///create RTM cahnnel
    func joinAgoraRtmChannel(withChannelID : String){
        guard let channel = kit?.createChannel(withId: Constant.AgoraKeys.AGORA_RTM_CHANNEL_NAME, delegate: self)
        else{
            print("error creating the channel")
            return
        }
        
        self.channel = channel
        //join the RTM cahnnel
        channel.join(completion: { [self] (errorCode) in
            if errorCode == AgoraRtmJoinChannelErrorCode.channelErrorOk{
                print("Joined Succesfully for user \(String(describing: self.agoraRtmUserID)). Code: \(errorCode)")
            }else{
                displayAlert(alertMessage: "Failed the Join the channel")
            }
        })
    }
    
    func leaveAoraRtmChannel(){
        guard let channel = channel else {
            print("Failed to leave Channel")
            return
        }
        channel.leave(completion: { [self] (errorCode) in
            if errorCode == AgoraRtmLeaveChannelErrorCode.ok{
                print("Joined Channel Succesfully Code: \(errorCode)")
            }else{
                displayAlert(alertMessage: "Failed to leave Channel Code: \(errorCode)")
            }
        })
    }
    
    func sendGroupMessage(withMessageText : String){
        
        //enable offlineMessaging service, as per your choice
        let option = AgoraRtmSendMessageOptions()
        option.enableOfflineMessaging = true
        
        guard let channel = channel else {
            print("Please join a channel to send message")
            return
        }
        
        channel.send(AgoraRtmMessage(text: withMessageText), sendMessageOptions: option, completion: { (errorCode) in
            if errorCode == AgoraRtmSendChannelMessageErrorCode.errorOk{
                print("Message sent to channel")
            }else{
                self.displayAlert(alertMessage: "Failed to send message")
            }
            
            //add the current new comment created in the tableView
            self.appendMessage(user: self.agoraRtmUserID!, content: withMessageText)
        })
    }
}

//MARK: - AgoraRtmDelegate functions
extension LiveStreamVC: AgoraRtmDelegate{
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        print("connection state changed")
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        appendMessage(user: peerId, content: message.text)
    }
}

//MARK: - AgoraRtmChannelDelegate functions
extension LiveStreamVC : AgoraRtmChannelDelegate{
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        appendMessage(user: member.userId, content: message.text)
    }
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            print("\(member.userId) joined")
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            print("\(member.userId) left")
        }
    }
}
