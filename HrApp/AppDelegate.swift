//
//  AppDelegate.swift
//  Dhanbarse
//
//  Created by Goldmedal on 10/1/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import Crashlytics
import Fabric
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var tokenString = String()
    var wasAppKilled :Bool = false
    var isAppLaunched = Bool()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        // Override point for customization after application launch.
      
        IQKeyboardManager.shared.enable = true
        
        DropDown.startListeningToKeyboard()
        
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.darkGray
        
//        if #available(iOS 11.0, *) {
//            navigationBarAppearance.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.init(named: "FontDarkText") , NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!]
//        } else {
//            navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray , NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!]
//
//        }
        if #available(iOS 11.0, *) {
            navigationBarAppearance.barTintColor = UIColor.init(named: "Primary")
            
        } else {
            navigationBarAppearance.barTintColor = UIColor.gray
        }
        
        if #available(iOS 13.0, *) {
       
        }else{
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                   
                   if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                       if #available(iOS 11.0, *) {
                           statusBar.backgroundColor = UIColor.init(named: "Primary")
                       } else {
                           statusBar.backgroundColor = UIColor.gray
                       }
                   }
                   
                   
                   UIApplication.shared.statusBarStyle = .lightContent
        }
        
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                (granted,error) in
                if granted{
                    DispatchQueue.main.async(execute: {
                        application.registerForRemoteNotifications()
                    })
                    
                } else {
                    // print("User Notification permission denied: \(error?.localizedDescription)")
                }
                
            }
            
            
            // set the delegate in didFinishLaunchingWithOptions
            UNUserNotificationCenter.current().delegate = self
      
            //called when app is killed
            
            if launchOptions != nil{
                let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
                if userInfo != nil {
                    
                    wasAppKilled = true
                    
                    print("LAUNCH OPTIONS called")
             
                }
            }
        
          
            application.registerForRemoteNotifications()
            
            Messaging.messaging().shouldEstablishDirectChannel = true
            
            FirebaseApp.configure()
            
            Fabric.with([Crashlytics.self])
            
            Fabric.sharedSDK().debug = true
        
        
        
//        var analyticsMain = Utility.retriveCoreAnalyticsData()
//        print("ANALYTICS - - - - - -",analyticsMain.count)
//
//        if(analyticsMain.count>10){
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Analytics")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//            do {
//                try PersistenceService.context.execute(deleteRequest)
//            } catch let error as NSError {
//                // TODO: handle the error
//            }
//
//            var analyticsMain = Utility.retriveCoreAnalyticsData()
//            print("ANALYTICS CLEARED - - - - - -",analyticsMain.count)
//        }
        
             UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)
        
               return true
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (Utility.isConnectedToNetwork()) {
            var alert = UIAlertView(title: "Internet Connection", message: "Available", delegate: nil, cancelButtonTitle: "OK")
                       alert.show()
        }else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                       alert.show()
        }
    }
    
  
        // **********************   implementation of notification logic starts here ************************
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            
            let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
            }
             tokenString = tokenParts.joined()
            // 2. Print device token to use for PNs payloads
            print("Device Token: \(tokenString)")
            
           // tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            //tokenString = InstanceID.instanceID().token() ?? "-"
            UserDefaults.standard.set(tokenString, forKey: "deviceToken")
            print("InstanceID token: \(tokenString)")
         
        }
        
        
        func application(received remoteMessage: MessagingRemoteMessage) {
            
            print(remoteMessage.appData)
        
        }
        
        
        func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
            
          // tokenString = InstanceID.instanceID().token()
           tokenString = fcmToken
            print("TOKEN STRING- - - - - ",fcmToken)
            
            Messaging.messaging().shouldEstablishDirectChannel = true
            
        }
        
        
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            
            Messaging.messaging().shouldEstablishDirectChannel = false
        }
        
        
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
            Messaging.messaging().shouldEstablishDirectChannel = true
        }
        
        
        // This method will be called when app received push notifications in foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
            
        {
            
            completionHandler([.alert, .badge, .sound])
            
        }
        
        @available(iOS 10.0, *)
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            //write your action here
            if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
                
                //let message = parseRemoteNotification(notification: notification)
                //print(message as Any)
                parseNotification(userInfo: notification)
              
            }
            completionHandler()
        }
        
        
        
        // - - - - - - - -  Parsing notification data here - - - - - - - - - - -
        func parseNotification(userInfo: [AnyHashable : Any]){
            if let notification = userInfo as? [String:AnyObject] {
               
            }
        }
        
        // - - - - - - - - - - Event triggered when notification is received when app is running  - - - - - - -
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("RECEIVE NOTIFICATION")
            
            parseNotification(userInfo: userInfo)
            
    //        SQLiteDB.instance.addNotification(NotificationId: (notificationId ?? "-")!, InformToServer: (informToServer ?? "-")!, CinNotif: (cin ?? "-")!, RedirectToActivity: (redirectToActivity ?? "-")!, Redirecturl: (redirecturl ?? "-")!, ImageUrl: (imageUrl ?? "-")!, Title: (title ?? "-")!, Body: (body ?? "-")!)
        }
        
        //  ***************************  End of notification logic ************************
        

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

   
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistenceService.saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "Dhanbarse")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

public enum Model : String {
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPad5              = "iPad 5", //aka iPad 2017
    iPad6              = "iPad 6", //aka iPad 2018
    //iPad mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    //iPad pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //aka iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //aka iPad 2018
            "iPad7,6"   : .iPad6,
            //iPad mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            //iPad pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            //AppleTV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
