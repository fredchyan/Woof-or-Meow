//
//  HelperFunctions.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/30/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit

func displayError(hostViewController: UIViewController, title: String, errorString: String){
    dispatch_async(dispatch_get_main_queue(), {
        let alert = UIAlertController(title: title, message: errorString, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        hostViewController.presentViewController(alert, animated: true, completion: nil)
    })
}

