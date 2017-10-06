//
//  CompletedStressorViewController.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 10/5/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import PDFGenerator

class CompletedStressorViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var subviewContainer: UIView!
    
    private var embeddedViewController: UIViewController?
    var stressor: Stressor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Share button
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareTapped))
        
        // Segmented Control
        
        self.segmentedControl.tintColor = UIColor.navBar
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.white] , for: .selected)
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.navBar] , for: .normal)
        
        // Initial Selection
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.didMakeSegmentedSelection(self.segmentedControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -
    
    @IBAction func didMakeSegmentedSelection(_ sender: UISegmentedControl) {
        
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0: // Action Plan
                let vc = UIStoryboard(name: "Actionplan", bundle: nil).instantiateInitialViewController() as! ActionViewController
                vc.currentStressor = stressor
                vc.isStressorCompleted = true
                vc.view.layer.contents = #imageLiteral(resourceName: "backgroundActionPlan").cgImage
                vc.view.layer.contentsGravity = kCAGravityResizeAspectFill
                return vc
            case 1: // Conversation
                let vc = UIStoryboard(name: "CompletedConversation", bundle: nil).instantiateInitialViewController() as! CompletedConversationTableViewController
                vc.currentStressor = stressor
                return vc
            case 2: // Takeaway
                let vc = UIStoryboard(name: "CompletedTakeaway", bundle: nil).instantiateInitialViewController() as! TakeAwayViewController
                vc.completed = true
                vc.currentStressor = stressor
                return vc
            default:
                return nil
            }
            }() else {
                assertionFailure()
                return
        }
        
        // Embed
        
        if let embeddedViewController = self.embeddedViewController {
            self.unembed(viewController: embeddedViewController)
        }
        
        self.embed(viewController: vc)
    }
    
    // MARK: -
    
    private func embed(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.subviewContainer.bounds
        self.subviewContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        self.embeddedViewController = viewController
    }
    
    private func unembed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        self.embeddedViewController = nil
    }
    
    // MARK: -
    
    @objc func shareTapped() {
        
        self.generatePDF { [unowned self] (destinationURL,error) in
            if let destinationURL = destinationURL {
                let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
                
                self.present(activityViewController, animated: true, completion: nil)
            }
            else {
                //todo handle errors?
            }
        }
    }
    
    // @ignacio: Update PDF generation so that we generate a pdf with each tab on a page
    // Not sure how it will look with a conversation that could be multiple pages long?
    
    private func generatePDF(completion: (URL?, Error?) -> ()) {
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(("CompletedStressor") + ".pdf"))
        
        do {
            
            //hide remind me button temporally
            
            let actionVC = UIStoryboard(name: "Actionplan", bundle: nil).instantiateInitialViewController() as! ActionViewController
            actionVC.currentStressor = stressor
            actionVC.isStressorCompleted = true
            actionVC.view.layer.contents = #imageLiteral(resourceName: "backgroundActionPlan").cgImage
            actionVC.remindMeButton.isHidden = true
            actionVC.view.layer.contentsGravity = kCAGravityResizeAspectFill
            actionVC.view.layoutIfNeeded()
            actionVC.view.frame.size = actionVC.scrollView.contentSize

            let conversationVC = UIStoryboard(name: "CompletedConversation", bundle: nil).instantiateInitialViewController() as! CompletedConversationTableViewController
            conversationVC.currentStressor = stressor
            conversationVC.view.layoutIfNeeded()
            
            let takeAwayVC = UIStoryboard(name: "CompletedTakeaway", bundle: nil).instantiateInitialViewController() as! TakeAwayViewController
            takeAwayVC.completed = true
            takeAwayVC.currentStressor = stressor
            takeAwayVC.view.layoutIfNeeded()
            
            try PDFGenerator.generate([actionVC.view, conversationVC.view, takeAwayVC.view], to: dst)
            
            print("PDF sample saved in: " + dst.absoluteString)
            completion(dst, nil)
            
        } catch (let error) {
            print(error)
            completion(nil, error)
        }
    }
}
