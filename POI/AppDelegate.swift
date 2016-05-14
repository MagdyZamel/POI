//
//  AppDelegate.swift
//  POI
//
//  Created by MSZ on 3/18/16.
//  Copyright © 2016 bey2ollak. All rights reserved.
//

import UIKit
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let savedname =  NSUserDefaults.standardUserDefaults().objectForKey("name") as! Array<String>?
       let image = UIImage(named: "hint")
        let image2 = UIImage(named: "HINT1")
        if savedname == nil || savedname?.count == 0{
        let firstPage = OnboardingContentViewController(title: "", body: "", image: resizeImage(image!), buttonText: "",action: nil)
        
        
      
            let secondPage = OnboardingContentViewController(title: "", body: "", image: resizeImage(image2!), buttonText: "",action: nil)
        
        
        let was = self.window?.rootViewController
        
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [firstPage, secondPage])
        
        onboardingVC.allowSkipping = true
        onboardingVC.hidePageControl = false
        onboardingVC.skipHandler = {

                  self.window?.rootViewController  =  was
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "AppScreens", bundle: nil)

            let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Main") as! MainScreenViewController
            
            
            rootViewController.navigationController?.pushViewController(profileViewController, animated: true)
                }

        self.window?.rootViewController = onboardingVC
        }
   return true
    }


    func resizeImage(image: UIImage) -> UIImage {
        let x = (0.08 * UIScreen.mainScreen().bounds.width)
print(x)
        let newWidth = UIScreen.mainScreen().bounds.width - (x * 2)
        let newHeight = UIScreen.mainScreen().bounds.height-100
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(x-29, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSUserDefaults.standardUserDefaults().synchronize()

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSUserDefaults.standardUserDefaults().synchronize()

    }




}