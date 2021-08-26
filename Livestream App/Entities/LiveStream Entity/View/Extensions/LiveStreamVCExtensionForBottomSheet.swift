//
//  LiveStreamVCExtensionForBottomSheet.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 26/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation


//MARK: - Public methods
extension LiveStreamVC {
    func presentBottomSheet() {
        let vc = BottomSheet()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.setBottomSheetTitle(withTitle: "")
        
        if liveStreamHostVideoStatus == .videoIsOn {
            vc.addNewButton(newButton: BottomSheetButton(imageName: "no-video-50", buttonTitle: "Stop Video"))
        }else{
            vc.addNewButton(newButton: BottomSheetButton(imageName: "video-call-45", buttonTitle: "Resume Video"))
        }
        
        if liveStreamHostAudioStatus == .audioIsOn {
            vc.addNewButton(newButton: BottomSheetButton(imageName: "no-audio-50", buttonTitle: "Stop Audio"))
        }else{
            vc.addNewButton(newButton: BottomSheetButton(imageName: "audio-50", buttonTitle: "Resume Audio"))
        }
        
        vc.addNewButton(newButton: BottomSheetButton(imageName: "feedback-50", buttonTitle: "Report"))
        vc.addNewButton(newButton: BottomSheetButton(imageName: "logout-rounded-left-50", buttonTitle: "Exit Livestream"))
        
        // keep false
        // modal animation will be handled in VC itself
        self.present(vc, animated: false)
    }
}

//MARK: - BottomSheetDelegate methods
extension LiveStreamVC : BottomSheetDelegate{
    
    func bottomSheetButtonPressed(atIndex: Int) {
        if(atIndex == 0){
            if liveStreamHostVideoStatus == .videoIsOn {
                stopVideoStream()
            }else{
                startVideoStream()
            }
            
            
        } else if(atIndex == 1){
            if liveStreamHostAudioStatus == .audioIsOn {
                stopAudioStream()
            }else{
                startAudioStream()
            }
            
            
        } else if(atIndex == 3){
            presentCustomAlert()
        }
        
    }
    
}

//MARK: - Enums
public enum LiveStreamHostAudioStatus{
    case audioIsOn
    case audioIsOff
}

public enum LiveStreamHostVideoStatus {
    case videoIsOn
    case videoIsOff
}
