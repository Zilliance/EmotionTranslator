//
//  ExamplePopUpViewController.swift
//  Zilliance
//
//  Created by ricardo hernandez  on 5/8/17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

//  We need a more generic popup that takes this form and let's the user set the text
//  without this class knowing anything about the FeelBetterType

import UIKit
import MZFormSheetPresentationController

class LearnMoreViewController: UIViewController {
    
    enum Size {
        case small
        case large
    }
    
    static func present(from viewController: UIViewController, text: String, size: Size = .small) {
        let vc = UIStoryboard(name: "LearnMore", bundle: nil).instantiateInitialViewController() as! LearnMoreViewController
       
        vc.text = text
        
        let sheet = MZFormSheetPresentationViewController(contentViewController: vc)
        let width = UIDevice.isSmallerThaniPhone6 ? 260 : 300
        let height = size == .small ? 300 : (UIDevice.isSmallerThaniPhone6 ? 360 : 480)
        
        sheet.presentationController?.contentViewSize = CGSize(width: width, height: height)
        sheet.contentViewControllerTransitionStyle = .bounce
        
        viewController.present(sheet, animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override var title: String? {
        didSet {
            if self.isViewLoaded {
                self.titleLabel.text = self.title ?? "Learn More"
            }
        }
    }
    
    var text: String? {
        didSet {
            if self.isViewLoaded {
                self.textView.text = self.text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.titleLabel.text = self.title ?? "Learn More"
        self.textView.text = self.text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
        // Stupid, otherwise text view doesn't start with content at top
    }
   
    @IBAction func closeAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
}
