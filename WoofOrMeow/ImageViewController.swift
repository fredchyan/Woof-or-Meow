//
//  ImageViewController.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/24/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController {
    
    var submission: RedditSubmission? // Temporary Context
    var favoritedsubmission: RedditSubmission? // Persistent Context
    var temporaryContext: NSManagedObjectContext!

    @IBOutlet weak var watsonButton: WatsonButton!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Coming from FavotiteViewController
        if let image = favoritedsubmission?.image{
             imageView.image = favoritedsubmission?.image
        }
        else if let image = submission?.image {
            imageView.image = submission?.image
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "addToFavorite")
        let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "share")
        self.navigationItem.setRightBarButtonItems([saveButton, shareButton], animated: true)
        watsonButton.actionBlock = { weakButton -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.Analysis()
                //weakButton.finish()
            })
        }
    }
    
    func addToFavorite() {
        if let submission = submission {
            // Prevent duplicating favorites
            let fetchRequest = NSFetchRequest(entityName: "RedditSubmission")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "name == %@", submission.name!)
            if let fetchResults = sharedContext.executeFetchRequest(fetchRequest, error: nil) as? [RedditSubmission] {
                if fetchResults.count != 0 {
                    displayError(self, "Hrmph... 🐾", "This picture has already been added to the favorites.")
                } else {
                    let dictionary: [String : AnyObject] = [
                        RedditSubmission.Keys.URL : submission.url!,
                        RedditSubmission.Keys.Name : submission.name!,
                        RedditSubmission.Keys.Title : submission.title!
                    ]
                    let submissionToBeAdded = RedditSubmission(dictionary: dictionary, insertIntoManagedObjectContext: sharedContext)
                    saveContext()
                    displayError(self, "Success! 🎉", "This picture is now saved to the favorites.")
                }
            }
        } else {
            displayError(self, "Hrmph... 🐾", "This picture has already been added to the favorites.")
        }
        
    }
    
    

    func Analysis() {
        if (favoritedsubmission != nil) {
            if favoritedsubmission?.predictions.count == 0 {
                if let image = favoritedsubmission?.image {
                    Watson.sharedInstance().taskForVisualRecognition(image){ result, error in
                        for eachLabel in result! {
                            var newWatsonResult = WatsonResult(dictionary: eachLabel, insertIntoManagedObjectContext: self.sharedContext)
                            newWatsonResult.submission =  self.favoritedsubmission!
                            self.saveContext()
                            self.watsonButton.finish()
                        }
                        self.displayWatsonResult(self.favoritedsubmission!.predictions)
                    }
                }
            } else {
                self.displayWatsonResult(self.favoritedsubmission!.predictions)
                watsonButton.finish()
            }
        }
        else if submission?.predictions.count == 0 && submission?.image != nil{
            if let image = submission?.image {
                Watson.sharedInstance().taskForVisualRecognition(image){ result, error in
                    for eachLabel in result! {
                        // Don't need to save, use temporary context
                        var newWatsonResult = WatsonResult(dictionary: eachLabel, insertIntoManagedObjectContext: self.temporaryContext)
                        newWatsonResult.submission = self.submission!
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.watsonButton.finish()
                        self.displayWatsonResult(self.submission!.predictions)
                    }
                }
            }
        }else{
            watsonButton.finish()
            displayWatsonResult(self.submission!.predictions)
        }
        
    }
    
    func displayWatsonResult(predictions: [WatsonResult]){
        var alert_title = "Visual Recognition Result💫"
        var alert_msg = ""
        for eachPrediction in predictions {
            if (eachPrediction.labelName == "Dog"){
                alert_title = "Woof 🐶 It's a dog!"
            }
            if (eachPrediction.labelName == "Cat") {
                alert_title = "Meow 🐱 It's a cat!"
            }
            alert_msg = alert_msg + "\(eachPrediction.labelName) \(eachPrediction.labelScore)\n"
        }
        displayError(self, alert_title, alert_msg)
    }
    
    func share() {
        let activityViewController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (a: String!, ok: Bool, items:[AnyObject]!, err: NSError?) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }
    
    func saveContext() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
}