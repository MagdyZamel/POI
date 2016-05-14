//
//  FoursqueqrAPI.swift
//  POI
//
//  Created by MSZ on 3/18/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//

import Foundation
import Alamofire


class FoursquareAPI {
    
    //MARK:Attributes

    
    let client_id = "UWHUJGOLFXJTPGLJE3V15230PNWJLZB3CCV3KX22WSQVVZXY"
    let client_secret = "QJODHQ4MHET1ES4QAIUYROHWOB42RJVBKWZ3XZXZUH1RKEGC"
    var longitude = ""
    var latitude = ""


    
    func loadVenues( completion: (([Venue]) -> Void)!) {
       
        var venues = [Venue]()

        //let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            let Url = "https://api.foursquare.com/v2/venues/search?client_id=\(self.client_id)&client_secret=\(self.client_secret)&v=20130815&ll=\(self.latitude),\(self.longitude)"
            
            Alamofire.request(.GET, Url).responseJSON { response in
                
                if let JSON = response.result.value {

                    let alldata :[[String : AnyObject]] = JSON["response"]!!["venues"] as! [[String : AnyObject]]
                    for venen in alldata{
                        
                        let cc = Venue(data: venen)
                        venues = venues + [cc]
                    }
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(venues)
                    }
                }

                
                }.task.resume()
            
        
        
    }

}