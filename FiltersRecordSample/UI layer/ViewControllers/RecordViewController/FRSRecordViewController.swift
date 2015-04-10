//
//  FRSRecordViewController.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/7/15.
//  Copyright (c) 2015 Work. All rights reserved.
//

import UIKit

class FRSRecordViewController: FRSBaseViewController, FRSGPUImageWrapperDelegate {

    @IBOutlet weak var interfaceContainerView: UIView!
    
    @IBOutlet weak var filtersView: UIView!
    
    @IBOutlet weak var blinkView: VRSBlinkView!
    @IBOutlet weak var startRecordButton: FRSRecordButton!
    @IBOutlet weak var stopRecordButton: FRSRecordButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var filtersButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var gpuImageWrapper:FRSGPUImageWrapper!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var previewView:GPUImageView = self.view as! GPUImageView
        previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        
        var gpuImageWrapper:FRSGPUImageWrapper = FRSGPUImageWrapper(previewView: previewView, orientation: UIApplication.sharedApplication().statusBarOrientation)
        
        gpuImageWrapper.filterType = .Empty
        
        gpuImageWrapper.delegate = self
        
        self.gpuImageWrapper = gpuImageWrapper
        FRSBusinessFacade.sharedInstance.gpuImageWrapper = gpuImageWrapper
    }
    
    // MARK: Oriention
    
    override func shouldAutorotate() -> Bool {
        
        
        if (self.gpuImageWrapper.isRecorded == true) {
            return false
        }
        
        self.gpuImageWrapper.videoCamera.outputImageOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        return true
    }
    
    // MARK: IBActions
    
    @IBAction func startRecordAction(sender: FRSRecordButton) {
        
        self.lockUI()
        
        self.blinkView.startBlinkAnimation()
        
        self.gpuImageWrapper.startRecord()
        
        self.startRecordButton.hidden = true
        self.stopRecordButton.hidden = false
    }
    
    @IBAction func stopRecordAction(sender: FRSRecordButton) {
        
        self.gpuImageWrapper.stopRecord()
        
    }

    @IBAction func previewAction(sender: AnyObject) {
        self.previewVideo(self.gpuImageWrapper.currentVideoURL)
    }
    
    @IBAction func flipCameraAction(sender: UIButton) {
        self.gpuImageWrapper.videoCamera.rotateCamera()
    }
    
    @IBAction func filtersAction(sender: UIButton) {
        self.showFiltersList()
    }
    
    @IBAction func saveAction(sender: UIButton) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveVideoCompletion:", name: FRSBusinessFacade.sharedInstance.kSaveVideoCompletionNotificationString, object: nil)
        
        FRSBusinessFacade.sharedInstance.saveVideo()
    }
        
    // MARK: Lock UI
    
    func lockUI() {
        self.flipCameraButton.hidden = true
        self.previewButton.hidden = true
        self.filtersButton.hidden = true
        self.saveButton.hidden = true
    }
    
    func unlockUI() {
        self.flipCameraButton.hidden = false
        self.previewButton.hidden = false
        self.filtersButton.hidden = false
        self.saveButton.hidden = false
    }
    
    // MARK: FRSGPUImageWrapperDelegate
    
    func recordingProgress(progress:Double) {
        self.progressLabel.text = DurationFromTimeInterval(progress)
    }
    
    func recordIsFinished() {
        self.stopRecordButton.hidden = true
        self.startRecordButton.hidden = false
        
        self.blinkView.stopBlinkAnimation()
        
        self.unlockUI()
    }
    
    // MARK: Filters list
    
    func showFiltersList() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideFiltersListView:", name: FRSFiltersViewController().kHideFiltersListViewNotificationString, object: nil)
        self.interfaceContainerView.hidden = true
        self.filtersView.hidden = false
    }
    
    func hideFiltersList() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: FRSFiltersViewController().kHideFiltersListViewNotificationString, object: nil)
        self.interfaceContainerView.hidden = false
        self.filtersView.hidden = true
    }
    
    // MARK: Notification
    
    func hideFiltersListView(notification: NSNotification) {
        self.hideFiltersList()
    }
    
    func saveVideoCompletion(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: FRSBusinessFacade.sharedInstance.kSaveVideoCompletionNotificationString, object: nil)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.showOkAlert("Save complete!", message: nil)
    }
}
