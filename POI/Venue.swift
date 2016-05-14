//
//  Venue.swift
//  POI
//
//  Created by MSZ on 3/18/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Venue {

    
    //MARK:Attributes
    
    
    
    var name: String?
    var address:String?
    var prefix:String!
    var suffix:String!
    var size:String!
    var url:String!
    var image:UIImage?
    var flage = 0
    var favourite = false
    
    
    //Marrk : Initializers
    
    init(data:NSDictionary) {
        
        
        name = data["name"] as? String
        self.address = getDataFromaddress(data)
        self.prefix = getDataFromX(data,key: "prefix")
        suffix = getDataFromX(data,key: "suffix")
        size = "bg_88"
        url = prefix+size+suffix
        if let link = NSURL(string:  url) as NSURL?{
            downloadImage(link)
        }else{
            self .image = UIImage(named:"Error")
            
        }
        
    }
    
    init(Name:String, Address:String, url :String) {
        
        
        name = Name
        self.address = Address
        self.prefix = ""
        suffix = ""
        size = ""
        
        self.url = url
        if let link = NSURL(string:  url) as NSURL?{
            downloadImage(link)
        }else{
            self .image = UIImage(named:"Error")
            
        }

    }

    
    //MARK: Venue Functions
    
    // cheak adresess
    func getDataFromaddress(data:NSDictionary)->String{
    
      if let _ = data["location"]! as? NSDictionary{
            if let address = data["location"]!["address"]  as? String{
            
            return address
            }
        }
        return"Not Found Address"
        
    }
    
    
    // cheak prefix and suffix

    func getDataFromX(data:NSDictionary,key:String)->String{
        var x = data["categories"] as? [AnyObject]
        if x?.count>0{
            
            if let _ = x?[0]  as? NSDictionary{
                
                if let address = data["categories"]![0]["icon"]!![key] as? String{
                    return address
                    
                }
            }
        }
        flage++
        return"Not Found"
        
        }
    
    

    
    //MARK:load image by my function
    
    
    //  Create a function to get the data from your url
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    //Create a function to download the image (start the task)

    func downloadImage(url: NSURL )  {
        getDataFromUrl(url) { (data, response, error)  in
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
                guard let data = data where error == nil else { return }
                self.image = UIImage(data: data)!
                
            }
        }
        
    }
    
    
    
    
    
    
}