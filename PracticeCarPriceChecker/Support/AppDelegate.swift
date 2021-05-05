//
//  AppDelegate.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 12/12/20.
//  Copyright © 2020 Abraham Shenghur. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
        return true
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createSavedVehiclesNC() -> UINavigationController {
        let savedVehiclesVC = SavedVehiclesVC()
        let tabBarIcon = UIImage(named: "savedVehiclesTabBarIcon")
        savedVehiclesVC.title = "Saved Vehicles"
        savedVehiclesVC.tabBarItem = UITabBarItem(title: "Saved Vehicles", image: tabBarIcon, tag: 1)
        
        return UINavigationController(rootViewController: savedVehiclesVC)
    }
    
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        tabBar.viewControllers = [createSearchNC(), createSavedVehiclesNC()]
        
        return tabBar
    }
    
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
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
    }


}

