//
//  ViewControllerExtensionForAgoraRTC.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 20/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation
import AgoraRtcKit

private var HostID : UInt? = nil

//MARK: - Agora RTC Manager
extension LiveStreamVC{
    
    func initializeAgoraEngine() {
        agoraRtcKit = AgoraRtcEngineKit.sharedEngine(withAppId: Constant.AgoraKeys.AGORA_RTC_APP_ID, delegate: self)
    }
    
    func setChannelProfile(){
        agoraRtcKit?.setChannelProfile(.liveBroadcasting)
    }
    
    func setClientRole(){
        // Set the client role as "host"
        //agoraRtcKit?.setClientRole(.broadcaster)
        // Set the client role as "audience"
        let options: AgoraClientRoleOptions = AgoraClientRoleOptions()
        options.audienceLatencyLevel = AgoraAudienceLatencyLevelType.lowLatency
        agoraRtcKit?.setClientRole(.audience, options: options)
    }
    
    func setupLocalVideo() {
        // Enables the video module
        agoraRtcKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        //videoCanvas.view = localView
        // Sets the local video view
        agoraRtcKit?.setupLocalVideo(videoCanvas)
    }
    
    func stopVideoStream(){
        if let id = HostID{
            agoraRtcKit?.muteRemoteVideoStream(id, mute: true)
        }
    }
    
    func startVideoStream(){
        if let id = HostID{
            agoraRtcKit?.muteRemoteVideoStream(id, mute: false)
        }
    }
    
    func stopAudioStream(){
        if let id = HostID{
            agoraRtcKit?.muteRemoteAudioStream(id, mute: true)
        }
    }
    
    func startAudioStream(){
        if let id = HostID{
            agoraRtcKit?.muteRemoteAudioStream(id, mute: false)
        }
    }
    
    func joinAgoraRtcChannel(){
        print("Joining Channel....")
        // The uid of each user in the channel must be unique.
        //AgoraRtcChannel().setRtcChannelDelegate(self)
        agoraRtcKit?.joinChannel(byToken: Constant.AgoraKeys.AGORA_RTC_TEMP_TOKEN, channelId: Constant.AgoraKeys.AGORA_RTC_CHANNEL_NAME, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            
            print("Successfully Joined the Channel")
        })
    }
    
    
    
    func leaveAgoraRtcChannel() {
        print("Leaving Channel")
        agoraRtcKit?.leaveChannel(nil)
        
        //release the resources after
        //AgoraRtcEngineKit.destroy()
    }
    
    /* Not Working*/
    func getUserInfo(forUid : UInt){
        let temp = agoraRtcKit?.getUserInfo(byUid: forUid, withError: nil)
        print(temp?.userAccount)
    }
}

//MARK: - AgoraRtcEngineDelegate methods
extension LiveStreamVC : AgoraRtcEngineDelegate{
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraRtcKit?.setupRemoteVideo(videoCanvas)
        
        self.isHostLiveTextLabel.isHidden = false
        
        HostID = uid
        print(uid)
        getUserInfo(forUid: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.isHostLiveTextLabel.isHidden = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: stats.duration)
        var timeInString = ""
        if stats.duration >= 3600{
            timeInString = "\(h):\(m):\(s)"
        }else{
            timeInString = "\(m):\(s)"
        }
        self.livestreamUptimeTextLabel.text = timeInString
        
        self.activePeopleInLivestreamTextLabel.text = String(stats.userCount)
    }
    
    /* Not Working*/
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        print(stats.publishDuration)
    }
    
    /* Not Working*/
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        print(userInfo.uid)
        print(userInfo.userAccount)
    }
    
}

//MARK: - AgoraRtcChannelDelegate methods
extension LiveStreamVC : AgoraRtcChannelDelegate{
    
    /* Not Working*/
    func rtcChannel(_ rtcChannel: AgoraRtcChannel, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        print(stats.publishDuration)
    }
    

}

//MARK: - Private methods
private extension LiveStreamVC{
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
