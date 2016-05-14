//
//  Venuse.swift
//  POI
//
//  Created by MSZ on 3/18/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//
import UIKit
import Alamofire


class VenuseViewController: UIViewController ,UITableViewDelegate{
    
    //MARK:Attributes

    @IBOutlet weak var venuseTableview: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var api = FoursquareAPI()
    let favourite = MyFavouritePOI()
    var guidImage = UIImageView()

    var venues = [Venue]()
    var latitude = ""
    var longitude = ""
    
    var isChecked:Bool = false
    
    func runGuidImage(){
        
        let Image = UIImage(named: "guidImage")
        guidImage = UIImageView(image: Image)
        guidImage.frame = CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height - 40-44)
        guidImage.alpha = 0.8
        guidImage.hidden = true
        view.addSubview(guidImage)
        
    }


    //MARK:function of view load

    override func viewDidLoad() {
        super.viewDidLoad()
        self.venuseTableview.separatorStyle = UITableViewCellSeparatorStyle.None

        self.view.makeToastActivity(message: "Loading")
        
        api.latitude = latitude
        api.longitude = longitude
        self.api.loadVenues(WaitingForDownload)
        self.venuseTableview.reloadData()
        
        
        
    }
    
    //recive data
    
    func WaitingForDownload(ven: [Venue]){
        self.venues = ven
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.venuseTableview.reloadData()
            
        }
        
        venuseTableview.hidden = false
        self.view.hideToastActivity()
        
        
    }
    
    
    //MARK:TABLEVIEW DELEGATE
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if venues.count != 0{
            
            return venues.count
            
        }
        return 0
    }
    
    // There is just one row in every section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    
    // Make the background color show through
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:VenuseUITableViewCell = self.venuseTableview.dequeueReusableCellWithIdentifier("Near") as!  VenuseUITableViewCell
        cell.name.text = venues[indexPath.section].name
        cell.adress.text = venues[indexPath.section].address
        cell.favourte.tag = indexPath.section
        cell.imageView?.image = self.venues[indexPath.section].image

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.venuseTableview.reloadData()
            cell.favourte.isChecked = false
            
        }
        
        if  let saved =  defaults.objectForKey("name") as! Array<String>?{
            
            if favourite.founded(venues[indexPath.section].name!, saved: saved,state_Func : "add").0==true{
                cell.favourte.isChecked = true
            }
        }
        return cell
    }
    
    // to disable Highlight when table view cell is tapped
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
        return false
    }
    
    
    //MAARK:Make Favourite Venuse
    
    
    
    @IBAction func MakeFavourite(sender:CheckBox) {
        let index  = sender.tag
        
        if sender.isChecked == false {
            favourite.AddOrRemoveToMyData("name", Index: index, state_value: 1, state_Func: "add",venues: venues)
            favourite.AddOrRemoveToMyData("add", Index: index, state_value: 2, state_Func: "add",venues: venues )

            favourite.AddOrRemoveToMyData("url", Index: index, state_value: 3, state_Func: "add",venues: venues)

            
            
            sender.isChecked = true
            
        }else{
            favourite.AddOrRemoveToMyData("name", Index: index, state_value: 1, state_Func: "remove",venues: venues)
            favourite.AddOrRemoveToMyData("add", Index: index, state_value: 2, state_Func: "remove",venues: venues)
            favourite.AddOrRemoveToMyData("url", Index: index, state_value: 3, state_Func: "remove",venues: venues)
            
            sender.isChecked = false
            
            
            
        }
        
    }
    
    
    
    
    
    
}
