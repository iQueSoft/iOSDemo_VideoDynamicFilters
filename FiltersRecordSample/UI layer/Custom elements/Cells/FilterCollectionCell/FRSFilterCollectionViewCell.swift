//
//  FRSFilterCollectionViewCell.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import UIKit

class FRSFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var previewView: GPUImageView!
    
    var filtersGroup:GPUImageFilterGroup!
    var filterType:FRSFilter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 4.0
    }
    
    func setupCell(filterType:FRSFilter, gpuImageWrapper:FRSGPUImageWrapper) {
        
        self.filterType = filterType
        
        var filter:GPUImageFilter? = gpuImageWrapper.filterForType(filterType)
        
        if (filter == nil) {
            gpuImageWrapper.videoCamera.addTarget(self.previewView)
            return
        }
        
        self.filtersGroup = GPUImageFilterGroup()
        
        self.filtersGroup.addFilter(filter!)
        self.filtersGroup.initialFilters = [filter!]
        self.filtersGroup.terminalFilter = filter!
        
        filtersGroup.addTarget(self.previewView)
        
        gpuImageWrapper.videoCamera.addTarget(filtersGroup)

    }
    
}
