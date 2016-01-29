//
//  Watson.swift
//  WoofOrMeow
//
//  Created by Nightlock on 8/16/15.
//  Copyright (c) 2015 Frederick Chyan. All rights reserved.
//

import UIKit

class Watson : NSObject {
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForVisualRecognition (img: UIImage, completionHandler: (result: [[String:AnyObject]]?, error: String?) -> Void ){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://woof-or-meow.mybluemix.net/uploadpic")!)
        //var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/uploadpic")!)
        request.HTTPMethod = "POST"
        let imageData = UIImageJPEGRepresentation(img, 0.9)
        let body:NSMutableString = NSMutableString()
        let boundaryConstant = "Boundary-hPCkAVcBB7cbabuz";
        //let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let mimeType = "image/jpeg"
        let fileName = "abcde.jpg"
        let fieldName = "image"
        
        body.appendFormat("--\(boundaryConstant)\r\n")
        body.appendFormat("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        body.appendFormat("Content-Type: \(mimeType)\r\n\r\n")
        let end:String = "\r\n--\(boundaryConstant)--\r\n"
        
        let myRequestData:NSMutableData = NSMutableData()
        myRequestData.appendData(body.dataUsingEncoding(NSUTF8StringEncoding)!)
        myRequestData.appendData(imageData!)
        myRequestData.appendData(end.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = myRequestData
        
        let content:String = "multipart/form-data; boundary=\(boundaryConstant)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(myRequestData.length)", forHTTPHeaderField: "Content-Length")
        request.addValue("en", forHTTPHeaderField: "Accept-Language")

        let dataTask = session.dataTaskWithRequest(request){ data, response, error in
            if (error != nil) { return }
            do {
                let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
                let images = parsedResult!["images"] as! [AnyObject]
                let image0 = images[0] as! [String: AnyObject]
                let labels = image0["labels"] as! [[String : AnyObject]]
                completionHandler(result: labels, error: nil)
            } catch {
                print("json error \(error)")
                completionHandler(result: nil, error: "\(error)")

            }

        }
        dataTask.resume()
    }

    // MARK: - Shared Instance
    
    class func sharedInstance() -> Watson {
        
        struct Singleton {
            static var sharedInstance = Watson()
        }
        
        return Singleton.sharedInstance
    }
    
    
}
