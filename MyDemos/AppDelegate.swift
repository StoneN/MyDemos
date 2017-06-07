//
//  AppDelegate.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: - SearchBar Setting
        UISearchBar.appearance().barTintColor = UIColor.demoGreen()
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.demoGreen()
        
        
        // MARK: - Homepwner Setting (just for test!)
//        let itemStore = ItemStore()
//        let itemsController = window!.rootViewController as! ItemsViewController
//        itemsController.itemStore = itemStore
        
        // MARK: - PhotoScroll
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        return true
    }
}

extension UIColor {
    static func demoGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
}
