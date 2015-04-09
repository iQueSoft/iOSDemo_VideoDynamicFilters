//
//  FRSRecordButton.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 Work. All rights reserved.
//

import UIKit

class FRSRecordButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 3.0
        
        var cornerRadius:CGFloat = self.frame.height / 2.0
        self.layer.cornerRadius = cornerRadius
    }

}
