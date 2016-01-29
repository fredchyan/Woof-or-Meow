//
//  PhotoWallViewController.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/14/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit
import CoreData

class PhotowallViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var temporaryContext: NSManagedObjectContext!
    var submissions = [RedditSubmission]()
    var selectedIndex = 0
    var selectedImage: UIImage!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
        loadMoreData(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreData( lastSubmissionName: String? ) {
        Reddit.sharedInstance().taskForRedditData(lastSubmissionName) { (result, error) -> Void in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {displayError(self, title: "Oops...! 😿", errorString: error)})
                return
            }
            do{
                let regex = try NSRegularExpression(pattern: "imgur\\.com\\/[a-zA-z0-9]*\\.jpg", options: [])
                for eachEntry in result! {
                    let currentSubmission = RedditSubmission(dictionary: eachEntry, insertIntoManagedObjectContext: self.temporaryContext)
                    let url = currentSubmission.url! as NSString
                    if let _ = regex.firstMatchInString(url as String, options: [], range: NSMakeRange(0, url.length)) {
                        self.submissions.append(currentSubmission)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {self.collectionView.reloadData()})
            } catch {
                print("regex error \(error)")
            }
            
        }
    }
    
    
    // MARK: - UICollectionView
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let width = floor(self.collectionView.frame.size.width/2)
        layout.itemSize = CGSize(width: width-1, height: width-1)
        collectionView.collectionViewLayout = layout
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotowallCell", forIndexPath: indexPath) as! PhotowallCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: PhotowallCell, atIndexPath indexPath: NSIndexPath) {
        let submission = submissions[indexPath.row]
        let session = NSURLSession.sharedSession()
        let imageURL = NSURL(string: submission.url!)
        let request = NSURLRequest(URL: imageURL!)
        
        cell.imageView.image = nil
        cell.imageView.backgroundColor = UIColor.darkGrayColor()
        if submission.image != nil {
            cell.imageView.image = submission.image
        } else {
            cell.activityIndicator.startAnimating()
            let task = session.dataTaskWithRequest(request) { (data, response, downloadError) -> Void in
                if data == nil {
                    return
                }
                if let image = UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let updateCell = self.collectionView.cellForItemAtIndexPath(indexPath) as? PhotowallCell {
                            updateCell.imageView.image = image
                        }
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
            cell.taskToCancelifCellIsReused = task
            task.resume()
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == submissions.count - 1 ) {
            loadMoreData(submissions.last?.name)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedIndex = indexPath.row
        if let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as? PhotowallCell {
            submissions[selectedIndex].image = selectedCell.imageView.image
            self.performSegueWithIdentifier("showImageDetail" , sender: self)
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImageDetail" {
            let imageVC = segue.destinationViewController as! ImageViewController
            imageVC.submission = submissions[selectedIndex]
            imageVC.temporaryContext = self.temporaryContext
        }
        
    }
    
    
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}

