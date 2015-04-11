//
//  FRSFiltersViewController.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import UIKit

class FRSFiltersViewController: FRSBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let kHideFiltersListViewNotificationString:String = "kHideFiltersListViewNotificationString"
    private let kFilterCollectionViewCellIdentifier:String = "kFilterCollectionViewCellIdentifier"
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        FRSBusinessFacade.sharedInstance.gpuImageWrapper.filterType = FRSFilter(rawValue: indexPath.row)!
        self.filtersCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        var gpuImageWrapper:FRSGPUImageWrapper = FRSBusinessFacade.sharedInstance.gpuImageWrapper
        (cell as! FRSFilterCollectionViewCell).setupCell(FRSFilter(rawValue: indexPath.row)!, gpuImageWrapper: gpuImageWrapper)

    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        var gpuImageWrapper:FRSGPUImageWrapper = FRSBusinessFacade.sharedInstance.gpuImageWrapper
        var filterCell:FRSFilterCollectionViewCell = cell as! FRSFilterCollectionViewCell
        
        if let filtersGroup = filterCell.filtersGroup {
            gpuImageWrapper.videoCamera.removeTarget(filterCell.filtersGroup)
        } else {
            gpuImageWrapper.videoCamera.removeTarget(filterCell.previewView)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FRSFilter.FiltersCount.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:FRSFilterCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kFilterCollectionViewCellIdentifier, forIndexPath: indexPath) as! FRSFilterCollectionViewCell
        
        var cellFilter:FRSFilter = FRSFilter(rawValue: indexPath.row)!
        var currentFilter:FRSFilter = FRSBusinessFacade.sharedInstance.gpuImageWrapper.filterType
        
        if (cellFilter == currentFilter) {
            cell.layer.borderColor = UIColor.redColor().CGColor
        } else {
            cell.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        return cell
    }

    // MARK: IBActions
    
    @IBAction func closeAction(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(kHideFiltersListViewNotificationString, object: self, userInfo: nil)
    }
    
}
