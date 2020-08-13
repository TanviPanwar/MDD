//
//  AppDelegate.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import PopupDialog
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import Firebase
import Fabric



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor.clear
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        IQKeyboardManager.shared.disabledToolbarClasses = [ForgotQuestionsViewController.self, SignUpFourthStepVC.self, HireMDDViewController.self, SearchInd_EmpViewController.self]
        
        
        
        
        let login = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedIn)
        
        if login is String  {
            
            if (login as! String) == "login" {

                let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                let vc :HomeVC = storyBoard.instantiateViewController(withIdentifier:"HomeVC") as! HomeVC
               
                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = SideMenuController(contentViewController: vc,
                                                                menuViewController: menuViewController)
            }
 
            else {
                
                let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
                
                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                window = UIWindow(frame: UIScreen.main.bounds)
                
                window?.rootViewController = contentViewController
//                window?.rootViewController = SideMenuController(contentViewController: contentViewController,
//                                                                menuViewController: menuViewController)
//
            }
            
        }
        
        else {
            
            let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentNavigation")
            
            let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
            window = UIWindow(frame: UIScreen.main.bounds)
             window?.rootViewController = contentViewController
//            window?.rootViewController = SideMenuController(contentViewController: contentViewController,
//                                                            menuViewController: menuViewController)
//
            
        }
        
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
        
    }
    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        print(url.host)
        // "/cat365-reset-security-question"
        if url.host == domain {
        if url.absoluteString == "mddlink://www.mdd.com/cat365-login/?email=reset" {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//            let queryItems  = components?.queryItems
//            var tokenString = String()
//
//            for item  in queryItems! {
//                tokenString = item.value!
//            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpFourthStepVC") as! SignUpFourthStepVC
            vc.deepLinkCheck = true
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            
            
//            let nav = UINavigationController(rootViewController:vc)
//            self.window?.rootViewController = nav
            
        }
        else if  url.path == "/cat365-login" {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
           
            let appdelegate =  UIApplication.shared.delegate as! AppDelegate
            let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: K_Login_Stroyboard_Id) as! LoginVC
            let nav = UINavigationController(rootViewController: vc)
            appdelegate.window?.rootViewController = nav
            
            }

       }
        
        
        //        NSMutableDictionary *dict = [NSMutableDictionary new];
        //        NSLog(@"host%@",[url host]);
        //        if([[url host] isEqualToString:@"domain"]){
        //            if([[url path] isEqualToString:@"/mypath"]){
        //
        //                NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        //                NSArray *queryItems = [components queryItems];
        //                for (NSURLQueryItem *item in queryItems)
        //                {
        //                    [dict setObject:[item value] forKey:[item name]];
        //                }
        //
        //                valueDict = dict;
        //                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        //                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //                ViewController *viewController =  [story instantiateViewControllerWithIdentifier:@"ViewController"];
        //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        //                self.window.rootViewController = nav;//making a view to root view
        //                [self.window makeKeyAndVisible];
        //
        //                return YES;
        //
        //
        //            }
        //        }
        return true;
    }
    
    
     // MARK: - Push Notification Delegates
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                deviceToken  = "\(result.token)"
            }
        }
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.

        print(userInfo)
        guard let notificationID = userInfo["gcm.notification.id"] as? String else { return }
        print(notificationID)

        
        var catTitle: String?
        if  let title =  userInfo["aps"] as? Dictionary<String,AnyObject>
        {
            if let alert = title["alert"] as? [String: Any] {
            
              catTitle = alert["title"] as? String ?? ""
                
            }
        }
        
        
        // completionHandler(UIBackgroundFetchResult.newData)
        
//                 if UIApplication.shared.applicationState != .background || UIApplication.shared.applicationState == .active {
        
        if (UIApplication.topViewController() is DetailViewController)
        {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.notificationId = notificationID
                vc.notificationTitle = catTitle ?? ""
                vc.checkNotification = true
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            })
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.notificationId = notificationID
            vc.notificationTitle = catTitle ?? ""
            vc.checkNotification = true
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            
            //navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MDD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

