//
//  ViewController.swift
//  POI
//
//  Created by MSZ on 3/18/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class MainScreenViewController: UIViewController, CLLocationManagerDelegate ,UITableViewDelegate ,UITextFieldDelegate{
    
    
    //MARK:Attributes

    @IBOutlet weak var lat: UITextField!

    @IBOutlet weak var long: UITextField!
    @IBOutlet weak var getPOI: UIButton!
    @IBOutlet weak var custom: UIButton!
    let favourite  = MyFavouritePOI()
    @IBOutlet weak var favouritetableview: UITableView!
  
    var latitudesended = ""
    var longitudesended = ""
    
    var  favouritePOI:[Venue]?
    let LocationManager:CLLocationManager = CLLocationManager()
    var longitude :String = ""
    var latitude :String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    var reachability :Reachability?
    var InternetIsConected  = true
    
    

    //MARK:function of view load

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.favouritetableview.separatorStyle = UITableViewCellSeparatorStyle.None

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        setupReachability()
        getLocation()
        favouritePOI = favourite.loadFavouriteVenue()
       
        self.favouritetableview.reloadData()
            

        
    }
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        favouritePOI = favourite.loadFavouriteVenue()

            self.favouritetableview.reloadData()
            
    }
    //MARK:TABLEVIEW DELEGATE

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if favouritePOI!.count != 0{
            
            return favouritePOI!.count
        
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    
    // Make the background color show through
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FavouriteUITableViewCell = self.favouritetableview.dequeueReusableCellWithIdentifier("favourite") as!  FavouriteUITableViewCell
        cell.name.text = favouritePOI![indexPath.section].name
        cell.adress.text = favouritePOI![indexPath.section].address
        cell.favourte.tag = indexPath.section
        cell.imageView?.image = self.favouritePOI![indexPath.section].image
        cell.favourte.isChecked = false

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.favouritetableview.reloadData()

            
        }
        
        if  let saved =  defaults.objectForKey("name") as! Array<String>?{
            
            if favourite.founded(favouritePOI![indexPath.section].name!, saved: saved,state_Func : "add").0==true{
                cell.favourte.isChecked = true
            }
        }
        return cell
    }
    
    // to disable Highlight when table view cell is tapped
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
        return false
    }
    

    
    //MARK:Location Func
    
    func getLocation(){
        
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestAlwaysAuthorization()
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
    
    }
    //Location Delegate method
    
     func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
    
            
            UIView.hr_setToastThemeColor(color: UIColor.grayColor())
            self.view.makeToast(message: "Enable Location Services ")
            getPOI.enabled = false
            custom.enabled = false
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        latitude = "\(locations[0].coordinate.latitude)"
        longitude = "\(locations[0].coordinate.longitude)"
    

    }
    
    

    @IBAction func getPOIAction(sender: AnyObject) {

        if sender.tag == 1{
            

            if  lat.text == "" || lat.text == "" {
                let alertController = UIAlertController(title: "Error", message:
                    "Enter The correct location", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Retry Input", style: UIAlertActionStyle.Default ,handler: nil ))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
                }
            latitudesended = lat.text!
            longitudesended = long.text!
        }else{
            latitudesended = latitude
            longitudesended = longitude

        }
        performSegueWithIdentifier("roll", sender: self)

    }
    
    
            override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if segue.identifier == "roll" {
                    let controller = segue.destinationViewController as!
                    VenuseViewController
                    controller.latitude = latitudesended
                    controller.longitude = longitudesended
                }
    
            }

    @IBAction func unFavourite(sender: CheckBox) {
    
     let index  = sender.tag
    
        favourite.AddOrRemoveToMyData("name", Index: index, state_value: 1, state_Func: "remove",venues: favouritePOI!)
        favourite.AddOrRemoveToMyData("add", Index: index, state_value: 2, state_Func: "remove",venues:
            favouritePOI!)
        favourite.AddOrRemoveToMyData("url", Index: index, state_value: 3, state_Func: "remove",venues: favouritePOI!
        )
        
        
        favouritePOI = favourite.loadFavouriteVenue()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.favouritetableview.reloadData()
            
        }


    }
    
    
    //Mark: textfiled delegate
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing( textField: UITextField) {
        custom.enabled = false
        textField.text = ""
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    custom.enabled = true
    latitudesended  = lat.text!
    longitudesended = long.text!
    
    return true
    }


//Mark :Reachability

    func setupReachability(){
        
        do {
            self.reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        do{
            try reachability!.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        reachability = note.object as? Reachability

        if reachability!.isReachable() {
            if reachability!.isReachableViaWiFi() {
                
                InternetIsConected = true
            } else {
                
                InternetIsConected = true

            }
        } else {

            InternetIsConected = false
             ShowAlert()

        }
    }
    
    
    func ShowAlert(){
    
        
            let alert = UIAlertView()
            
            if (InternetIsConected == false){
                alert.delegate = self
                alert.title = "Error"
                alert.message = "There is no internet connection \n Check the internet connection"
                alert.addButtonWithTitle("Try Again")
                alert.show()
                
            }
        }
        
    func alertView(alertView: UIAlertController, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex{
        case 0:
            ShowAlert()
        default:
            
            ShowAlert()
        }
        
        
    
    
}
    

}

