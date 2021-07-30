//
//  AppTabbarController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-09.
//

import UIKit

class AppTabbarController: UITabBarController {
    
   override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
}
