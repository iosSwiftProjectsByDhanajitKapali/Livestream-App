//
//  LivestreamVCExtensionForSceneClassDelegate.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 26/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

extension LiveStreamVC : SceneClassDelegate{
    func stopTheAudio() {
        stopAudioStream()
    }
    
    func startTheAudio() {
        startAudioStream()
    }
    
}
