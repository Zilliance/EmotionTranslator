//
//  AutoscrollableViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 07-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

import UIKit

class AutoscrollableViewController: UIViewController {
    
    private var keyboardOffset: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var editingViewFrame: CGRect? {
        return self.view.subviews.filter {
            $0.isFirstResponder == true
            }.first?.frame
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let statusBarHeight = self.prefersStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.size.height
        
        guard self.view.frame.origin.y - (self.navigationController?.navigationBar.frame.size.height ?? 0) - statusBarHeight == 0 else {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let editingViewFrame = self.editingViewFrame {
            
            let diff = self.view.frame.size.height - self.view.frame.size.height - editingViewFrame.origin.y - keyboardSize.height
            
            if (diff < 0) {
                
                let originalY = self.view.frame.origin.y
                
                self.view.frame.origin.y = max(self.view.frame.origin.y + diff, self.view.frame.origin.y - editingViewFrame.origin.y + 20)
                
                keyboardOffset = self.view.frame.origin.y - originalY
                
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y -= keyboardOffset
    }
    
    
    
}
