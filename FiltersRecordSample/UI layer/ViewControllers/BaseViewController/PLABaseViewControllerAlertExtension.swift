//
//  PLABaseViewControllerAlertExtension.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/8/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import Foundation

extension FRSBaseViewController {
    
    // MARK: Show alert
    
    func showOkAlert(title: String?, message: String?) {
        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            refreshAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
}