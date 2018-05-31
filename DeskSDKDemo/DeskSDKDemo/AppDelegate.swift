//
//  AppDelegate.swift
//  DeskSDKDemo
//
//  Created by rajesh-2098 on 07/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import CoreData
import ZohoDeskUIKit
import ZohoDeskSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,ZDAuthentication {

    var window: UIWindow?
    func getToken(completion: @escaping ((String) -> ())) {
        ZohoAuth.getOauth2Token { (token, error) in
            let token = "Zoho-oauthtoken \(token ?? "")"
            completion(token)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Possible options: "ZDDomain.us","ZDDomain.eu"
        let configuration =  SDKConfiguration(domain: ZDDomain.us)
        ZohoDeskSDK(configuration: configuration)
        ZohoDeskSDK.delegete = self

       let scope =  ["Desk.tickets.ALL","Desk.tickets.READ","Desk.tickets.WRITE","Desk.tickets.UPDATE","Desk.tickets.CREATE","Desk.tickets.DELETE","Desk.contacts.READ","Desk.contacts.WRITE","Desk.contacts.UPDATE","Desk.contacts.CREATE","Desk.tasks.ALL","Desk.tasks.WRITE","Desk.tasks.READ","Desk.tasks.CREATE","Desk.tasks.UPDATE","Desk.tasks.DELETE","Desk.basic.READ","Desk.basic.CREATE","Desk.settings.ALL","Desk.settings.WRITE","Desk.settings.READ","Desk.settings.CREATE","Desk.settings.UPDATE","Desk.settings.DELETE","Desk.search.READ","Zohosearch.securesearch.READ","aaaserver.profile.READ","zohocontacts.userphoto.READ","ZohoSupport.feeds.ALL","ZohoSupport.basic.ALL","VirtualOffice.messages.CREATE","profile.userphoto.UPDATE","profile.userinfo.READ","profile.orguserphoto.READ",
        ]
        

        ZohoAuth.initWithClientID(<#ClientID#>, clientSecret: <#ClientSecret#>, scope: scope, urlScheme: <#URLScheme#>, mainWindow: (UIApplication.shared.delegate?.window)!, accountsURL: <#accountsURL#>)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceapplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        ZohoAuth.handleURL(url, sourceApplication: sourceapplication, annotation: annotation)
        return true
        
    }
    
    ///Note that "application:openURL:options:" is only available in iOS 10 and above. If you are building with an older version of the iOS SDK, you can use:
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       return ZohoAuth.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    


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
     
    }
}

