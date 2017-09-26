//
//  ActionViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared

class ActionViewController: UIViewController {
    
    var currentStressor: Stressor!
    var gotoIntroduction: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil

    @IBOutlet weak var takeAwayLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.planViewed)

    }

    private func setupView() {
        
        for label in [self.takeAwayLabel, self.actionStepLabel] as [UILabel] {
            
            label.layer.cornerRadius = UIConstants.Appearance.cornerRadius
            label.layer.borderWidth = UIConstants.Appearance.borderWidth
            label.layer.borderColor = UIColor.lightGray.cgColor
            
        }
        
        let takeawayTestText = "oisdhfo sdoifn osdf o sdfoin sdfo soidf soidfn sdfoisdfn osdif nsodfi  os ndiosdf"
        let actionStepTestText = "oisdhfo sdoifn osdf o sdfoin sdfo soidf soidfn sdfoisdfn osdif nsodfi  os ndiosdf soidfn sdfoisdfn osdi soidfn sdfoisdfn osdi soidfn sdfoisdfn osdi"
        
        
        let takeawayString = "Takeaway \n\n\(takeawayTestText)"
        let actionStepString = "Action Step \n\n\(actionStepTestText)"
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 10.0;
        style.headIndent = 10.0;
        style.tailIndent = -10.0;
        
        let takeAwayAttributedString = NSMutableAttributedString(string: takeawayString, attributes: [NSParagraphStyleAttributeName: style])
        let actionStepAttributedString = NSMutableAttributedString(string: actionStepString, attributes: [NSParagraphStyleAttributeName: style])
        
        let takeawayRange = (takeawayString as NSString).range(of: takeawayTestText)
        takeAwayAttributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 14), range: takeawayRange)
        takeAwayAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkText, range: takeawayRange)
        
        let actionStepRange = (actionStepString as NSString).range(of: actionStepTestText)
        actionStepAttributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 14), range: actionStepRange)
        actionStepAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkText, range: actionStepRange)

        
        self.takeAwayLabel.attributedText = takeAwayAttributedString
        self.actionStepLabel.attributedText = actionStepAttributedString
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
