//
//  ViewControllerExtensionForAgoraRTC.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 20/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation
import AgoraRtcKit

//MARK: - Agora Live Streaming
extension LiveStreamVC{
    
    func initView() {
            // Initializes the remote video view. This view displays video when a remote host joins the channel
            remoteView = UIView()
            self.view.addSubview(remoteView)
            // Initializes the local video view. This view displays video when the local user is a host
            //localView = UIView()
            //self.view.addSubview(localView)
    }
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Constant.AgoraKeys.AGORA_RTC_APP_ID, delegate: self)
    }
    
    func setChannelProfile(){
        agoraKit?.setChannelProfile(.liveBroadcasting)
    }
    
    func setClientRole(){
        // Set the client role as "host"
        agoraKit?.setClientRole(.broadcaster)
        // Set the client role as "audience"
        let options: AgoraClientRoleOptions = AgoraClientRoleOptions()
        options.audienceLatencyLevel = AgoraAudienceLatencyLevelType.lowLatency
        agoraKit?.setClientRole(.audience, options: options)
    }
    
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        //videoCanvas.view = localView
        // Sets the local video view
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func joinAgoraRtcChannel(){
        print("Joining Channel....")
        // The uid of each user in the channel must be unique.
        agoraKit?.joinChannel(byToken: Constant.AgoraKeys.AGORA_RTC_TEMP_TOKEN, channelId: Constant.AgoraKeys.AGORA_RTC_CHANNEL_NAME, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            
            print("Successfully Joined the Channel")
        })
    }
    
    func leaveAgoraRtcChannel() {
        print("Leaving Channel")
        agoraKit?.leaveChannel(nil)
        
        //release the resources after
        //AgoraRtcEngineKit.destroy()
    }
}

extension LiveStreamVC : AgoraRtcEngineDelegate{
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
        
        self.isHostLiveTextLabel.isHidden = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.isHostLiveTextLabel.isHidden = true
    }
    
}
