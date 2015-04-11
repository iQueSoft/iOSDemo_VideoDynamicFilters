//
//  FRSBaseViewController.swift
//  FiltersRecordSample
//
//  Created by Ruslan Shevtsov on 4/7/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

import UIKit

import MediaPlayer

class FRSBaseViewController: UIViewController {

    func previewVideo(fileURL:NSURL?) {
        if (fileURL == nil) {
            return
        }
        var movieController:MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: fileURL)
        self.presentMoviePlayerViewControllerAnimated(movieController)
    }

}
