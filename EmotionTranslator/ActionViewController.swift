//
//  ActionViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared
import PDFGenerator

class ActionViewController: UIViewController {
    
    var currentStressor: Stressor!
    var gotoIntroduction: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil

    @IBOutlet weak var takeAwayLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.topView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.setupView()
        
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.planViewed)

    }

    private func setupView() {
        
        guard let takeAwayText = self.currentStressor.takeAwayText, let actionStepText = self.currentStressor.takeAwayActions else { return }
        
        
        let takeawayString = "Takeaway \n\n\(takeAwayText)"
        let actionStepString = "Action Step \n\n\(actionStepText)"
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 10.0;
        style.headIndent = 10.0;
        style.tailIndent = -10.0;
        
        let takeAwayAttributedString = NSMutableAttributedString(string: takeawayString, attributes: [NSParagraphStyleAttributeName: style])
        let actionStepAttributedString = NSMutableAttributedString(string: actionStepString, attributes: [NSParagraphStyleAttributeName: style])
        
        let takeawayRange = (takeawayString as NSString).range(of: takeAwayText)
        takeAwayAttributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 14), range: takeawayRange)
        takeAwayAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkText, range: takeawayRange)
        
        let actionStepRange = (actionStepString as NSString).range(of: actionStepText)
        actionStepAttributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 14), range: actionStepRange)
        actionStepAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkText, range: actionStepRange)

        
        self.takeAwayLabel.attributedText = takeAwayAttributedString
        self.actionStepLabel.attributedText = actionStepAttributedString
        
    }
    
    @objc func shareTapped() {
        self.generatePDF { [unowned self] (destinationURL,error) in
            
            if let destinationURL = destinationURL {
                
                let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
                
                self.present(activityViewController,
                             animated: true,
                             completion: nil)
            }
            else {
                
                //todo handle errors?
                
            }
            
        }
    }
    
    private func generatePDF(completion: (URL?, Error?) -> ()) {
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(("ActionPlan") + ".pdf"))
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([self.view], to: dst)
            
            print("PDF sample saved in: " + dst.absoluteString)
            completion(dst, nil)
            
        } catch (let error) {
            print(error)
            completion(nil, error)
        }
    }

}

// MARK: - CompassValidation

extension ActionViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ActionViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .actionplan
    }
}
