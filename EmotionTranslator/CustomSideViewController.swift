//
//  CustomSideViewController.swift
//  Zilliance
//
//  Created by Ignacio Zunino on 17-04-17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import Foundation
import UIKit
import SideMenuController

final class CustomSideViewController: SideMenuController
{
    static func initSideProperties() {
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
    }
    
    required init?(coder aDecoder: NSCoder) {
        CustomSideViewController.initSideProperties()
        super.init(coder: aDecoder)
    }
    
    init() {
        CustomSideViewController.initSideProperties()
        super.init(nibName: nil, bundle: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setupHome() {
        guard let home = UIStoryboard(name: "HomeViewController", bundle: nil).instantiateInitialViewController(), let sideController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateInitialViewController() else {
            assertionFailure()
            return
        }

        self.embed(centerViewController: home)
        self.embed(sideViewController: sideController)
        
    }
    
}
