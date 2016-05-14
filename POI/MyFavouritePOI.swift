//
//  MyFavouritePOI.swift
//  POI
//
//  Created by MSZ on 3/20/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//

import Foundation
//MAARK:Make Favourite Venuse
struct MyFavouritePOI{

    //MARK:Attributes

    let defaults = NSUserDefaults.standardUserDefaults()

    
    func AddOrRemoveToMyData(Key:String , Index:Int, state_value:Int, state_Func:String,venues:[Venue]){
        
        var value  = ""
        
        switch state_value {
        case  1:
            value = venues[Index].name!
        case 2 :
            value = venues[Index].address!
        case 3 :
            value = venues[Index].url!
        default :
            value = ""
            
        }
        
        
        if  var saved = defaults.objectForKey(Key) as! Array<String>?{
            if state_Func == "remove"{

            if founded(value, saved: saved,state_Func : state_Func).0==true{
                
                
                    saved=founded(value, saved: saved,state_Func : state_Func).1
                
                    defaults.setObject(saved, forKey: Key)
                }
                return
             
            }
            saved.append(value)
            defaults.setObject(saved, forKey: Key)
            
        }else{
            var favouritename = [String]()
            favouritename.append(value)
            
         defaults.setObject(favouritename, forKey:Key)
            
        }
    }
    
    
    func loadFavouriteVenue()->[Venue]{
        var favourit = [Venue]()
        if  var savedname =  defaults.objectForKey("name") as! Array<String>?{
            if  var savedadd =  defaults.objectForKey("add") as! Array<String>?{
                if  var savedurl =  defaults.objectForKey("url") as! Array<String>?{
                    var index=0
                    for  _ in savedname{
                        let x = Venue(Name: "\(savedname[index])", Address: savedadd[index], url: savedurl[index])
                        favourit.append(x)
                        
                            
                        index++
                        
                    }
                    
                }
            }
        }
        return favourit

    }
    
    
    
    
    
    func founded (name:String ,var saved:[String],state_Func : String)->(Bool,[String]){
        var index=0
        for item in saved{
            if name ==  item{
                
                if state_Func == "remove"{
                    saved.removeAtIndex(index)
                    
                }
                
                return (true,saved)
            }
            index++
            
        }
        
        return (false,saved)
        
    }


}
