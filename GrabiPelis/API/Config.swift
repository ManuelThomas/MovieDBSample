//
//  Config.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/21/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import SVProgressHUD

var movieApiKey = "5107f3521cb13a469639a31b52864092"

struct Config {
    
    static func startApp() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let nav = UINavigationController()
        appDelegate.navigationController = nav
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        appDelegate.window = window
        
        let operation: HomeOperation? = HomeOperation()
        operation?.execute()
        
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    }
    
}
