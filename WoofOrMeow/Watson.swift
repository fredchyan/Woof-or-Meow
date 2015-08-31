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
        var request = NSMutableURLRequest(URL: NSURL(string: "http://woof-or-meow.mybluemix.net/uploadpic")!)
        //var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/uploadpic")!)
        request.HTTPMethod = "POST"
        var imageData = UIImageJPEGRepresentation(img, 0.9)
        var body:NSMutableString = NSMutableString()
        let boundaryConstant = "Boundary-hPCkAVcBB7cbabuz";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let mimeType = "image/jpeg"
        let fileName = "abcde.jpg"
        let fieldName = "image"
        
        body.appendFormat("--\(boundaryConstant)\r\n")
        body.appendFormat("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        body.appendFormat("Content-Type: \(mimeType)\r\n\r\n")
        var end:String = "\r\n--\(boundaryConstant)--\r\n"
        
        var myRequestData:NSMutableData = NSMutableData()
        myRequestData.appendData(body.dataUsingEncoding(NSUTF8StringEncoding)!)
        myRequestData.appendData(imageData)
        myRequestData.appendData(end.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = myRequestData
        
        var content:String = "multipart/form-data; boundary=\(boundaryConstant)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(myRequestData.length)", forHTTPHeaderField: "Content-Length")
        request.addValue("en", forHTTPHeaderField: "Accept-Language")

        let dataTask = session.dataTaskWithRequest(request){ data, response, error in
            if (error != nil) { return }
            var parsingError: NSError?
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            if let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject] {
                if let parsingError = parsingError {
                    completionHandler(result: nil, error: parsingError.localizedDescription)
                } else {
                    let images = parsedResult["images"] as! [AnyObject]
                    let image0 = images[0] as! [String: AnyObject]
                    let labels = image0["labels"] as! [[String : AnyObject]]
                    completionHandler(result: labels, error: nil)
                }
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
