//
//  RedditSubmission.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/14/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit
import CoreData


class RedditSubmission: NSManagedObject {

    
    struct Keys {
        static let URL = "url"
        static let Name = "name"
        static let Title = "title"
    }
    
    @NSManaged var url: String?
    @NSManaged var name: String?
    @NSManaged var title: String?
    @NSManaged var date: NSDate
    @NSManaged var predictions: [WatsonResult]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("RedditSubmission", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        url = dictionary[Keys.URL] as? String
        name = dictionary[Keys.Name] as? String
        title = dictionary[Keys.Title] as? String
        date = NSDate()
    }
    
    var image: UIImage? {
        
        get {
            return Reddit.Caches.imageCache.imageWithIdentifier(name)
        }
        
        set {
            Reddit.Caches.imageCache.storeImage(newValue, withIdentifier: name!)
        }
    }
    
    override func prepareForDeletion() {
        self.image = nil
    }
    
}