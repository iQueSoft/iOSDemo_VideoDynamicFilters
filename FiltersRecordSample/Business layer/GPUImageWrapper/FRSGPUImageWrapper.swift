//
//  FRSGPUImageWrapper.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import Foundation

// Frameworks
import AVFoundation

enum FRSFilter: Int {
    case Empty
    case Brightness
    case Sepia
    case Grayscale
    case Inverted
    case Pixellated
    case PolkaDot
    case FiltersCount
}

protocol FRSGPUImageWrapperDelegate:class {
    func recordingProgress(progress:Double)
    func recordIsFinished()
}

class FRSGPUImageWrapper: NSObject {

    var previewView:GPUImageView!
    var videoCamera:GPUImageVideoCamera!
    var filtersGroup:GPUImageFilterGroup!
    var movieWriter:GPUImageMovieWriter!
    
    weak var delegate:FRSGPUImageWrapperDelegate?
    
    var currentVideoURL:NSURL?
    var filterType:FRSFilter = .Empty {
        didSet {
            self.updateFilter(self.filterForType(filterType))
        }
    }
    var recordintTimer: NSTimer?
    var isRecorded:Bool = false
    
    // MARK: Setup camera
    
    init(previewView:GPUImageView, orientation:UIInterfaceOrientation) {
        super.init()
        self.previewView = previewView
        self.videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .Back)
        self.videoCamera.outputImageOrientation = orientation
        self.videoCamera.startCameraCapture()
    }
    
    // MARK: Update filter
    
    func filterForType(filterType:FRSFilter) -> GPUImageFilter? {
        switch (filterType) {
        case .Brightness:
            var filter:GPUImageBrightnessFilter = GPUImageBrightnessFilter()
            filter.brightness = 0.5
            return filter
            
        case .Sepia:
            return GPUImageSepiaFilter()
            
        case .Grayscale:
            return GPUImageGrayscaleFilter()
            
        case .Inverted:
            return GPUImageColorInvertFilter()
            
        case .Pixellated:
            var filter:GPUImagePixellateFilter = GPUImagePixellateFilter()
            filter.fractionalWidthOfAPixel = 0.01
            return filter
            
        case .PolkaDot:
            return GPUImagePolkaDotFilter()
            
        default:
            break
        }
        
        return nil
    }
    
    private func updateFilter(filter:GPUImageFilter?) {
        
        self.videoCamera.removeAllTargets()
        
        if (self.filtersGroup != nil) {
            self.filtersGroup.removeAllTargets()
            self.filtersGroup = nil
        }
        
        if (filter == nil) {
            self.videoCamera.addTarget(self.previewView)
            return
        }
        
        self.filtersGroup = GPUImageFilterGroup()
        
        self.filtersGroup.addFilter(filter!)
        self.filtersGroup.initialFilters = [filter!]
        self.filtersGroup.terminalFilter = filter!
        
        self.filtersGroup.addTarget(self.previewView)
        
        self.videoCamera.addTarget(self.filtersGroup)
    }

    // MARK: Record process
    
    func startRecord() {
        
        self.isRecorded = true
        
        var url: NSURL? = FRSFileManager().urlForVideo()
        
        FRSFileManager().removeFile(self.currentVideoURL)
        self.currentVideoURL = url
        
        self.movieWriter = GPUImageMovieWriter(movieURL: url, size: CGSizeMake(1200, 720))
        self.videoCamera.audioEncodingTarget = self.movieWriter
        
        if (self.filtersGroup != nil) {
            self.filtersGroup.addTarget(self.movieWriter)
        } else {
            self.videoCamera.addTarget(self.movieWriter)
        }
        
        self.movieWriter.startRecording()
        
        self.startRecordTimer()
    }
    
    func stopRecord() {
        self.movieWriter.finishRecordingWithCompletionHandler({ [weak self] () -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self?.stopRecordTimer()
                
                if (self?.filtersGroup != nil) {
                    self?.filtersGroup.removeTarget(self?.movieWriter)
                } else {
                    self?.videoCamera.removeTarget(self?.movieWriter)
                }
                self?.videoCamera.audioEncodingTarget = nil
                self?.movieWriter = nil
                
                self?.isRecorded = false
                
                self?.delegate?.recordIsFinished()
            }
        })
    }
    
    // MARK: Timer
    
    func startRecordTimer() {
        self.recordintTimer = NSTimer(timeInterval: 0.1, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.recordintTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func stopRecordTimer() {
        self.recordintTimer?.invalidate()
        self.recordintTimer = nil
    }
    
    func timerDidFire(timer:NSTimer!) {
        var progress:Double = CMTimeGetSeconds(self.movieWriter.duration)
        self.delegate?.recordingProgress(progress)
    }

}
