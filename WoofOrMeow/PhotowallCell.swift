//
//  PhotowallViewCell.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/15/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit

class PhotowallCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}
