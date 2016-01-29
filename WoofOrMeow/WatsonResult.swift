//
//  WatsonResult.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/24/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import Foundation
import CoreData


class WatsonResult: NSManagedObject {
    
    @NSManaged var labelName: String
    @NSManaged var labelScore: Float
    @NSManaged var submission: RedditSubmission
    
    struct Keys {
        static let LabelName = "label_name";
        static let LabelScore = "label_score";
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("WatsonResult", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        labelName = dictionary[Keys.LabelName] as? String ?? "No Label!"
        labelScore = (dictionary[Keys.LabelScore] as? NSString)?.floatValue ?? 0.5
    }
    
}
