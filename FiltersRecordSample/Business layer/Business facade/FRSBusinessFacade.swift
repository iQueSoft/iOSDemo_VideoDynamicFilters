//
//  FRSBusinessFacade.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import Foundation

class FRSBusinessFacade: NSObject {

    let kSaveVideoCompletionNotificationString:String = "kSaveVideoCompletionNotificationString"
    
    var gpuImageWrapper:FRSGPUImageWrapper!
    
    // MARK: Singleton
    
    class var sharedInstance: FRSBusinessFacade {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: FRSBusinessFacade? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = FRSBusinessFacade()
        }
        return Static.instance!
    }
    
    // MARK: Save video
    
    func saveVideo() {
        let path:String? = self.gpuImageWrapper.currentVideoURL?.path
        
        if (path != nil) {
            UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "video:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: UnsafeMutablePointer<Void>) {
        NSNotificationCenter.defaultCenter().postNotificationName(kSaveVideoCompletionNotificationString, object: nil, userInfo: nil)
    }
}
