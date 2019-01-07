//
//  RootNavigationController.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 07-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask  {
        return UIInterfaceOrientationMask.all
    }

}
