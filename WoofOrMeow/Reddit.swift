//
//  Reddit.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/10/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import Foundation

class Reddit : NSObject {
    var session: NSURLSession
    
    private var inMemoryCache: NSCache
    
    override init() {
        session = NSURLSession.sharedSession()
        inMemoryCache = NSCache()
        super.init()
    }
    
    
    // Provide an array of data of each link in the given page
    func taskForRedditData ( lastItem: String?, completionHandler: (result: [[String:AnyObject]]?, error: String?) -> Void ){
        var url = NSURL(string: "https://www.reddit.com/r/aww/.json")!
        if let lastItem = lastItem {
            url = NSURL(string: "https://www.reddit.com/r/aww/.json?after=\(lastItem)")!
        }
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(result: nil, error: "Failed to download data from Reddit \(error)")
                return
            }
            var parsingError: NSError?
            var parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! [String: AnyObject]
            
            if let pageContent = parsedResult["data"]?["children"] as? [AnyObject] {
                var arrayOfDictionaries = [[String:AnyObject]]()
                for eachSubmission in pageContent {
                    if let data = eachSubmission["data"] as? [String:AnyObject] {
                        arrayOfDictionaries.append(data)
                    }
                }
                completionHandler(result: arrayOfDictionaries, error: nil)
            }
        })
        
        task.resume()
    }
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Reddit {

        struct Singleton {
            static var sharedInstance = Reddit()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - Shared Image Cache
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
}