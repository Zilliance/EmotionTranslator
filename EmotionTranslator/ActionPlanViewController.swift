//
//  ActionPlanViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ActionPlanViewController: UIViewController {
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil

    @IBOutlet weak var takeAwayLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        
        for label in [self.takeAwayLabel, self.actionStepLabel] as [UILabel] {
            
            label.layer.cornerRadius = UIConstants.Appearance.cornerRadius
            label.layer.borderWidth = UIConstants.Appearance.borderWidth
            label.layer.borderColor = UIColor.lightGray.cgColor
            
        }
        
        self.takeAwayLabel.text = "oisdhfo sdoifn osdf o sdfoin sdfo soidf soidfn sdfoisdfn osdif nsodfi  os ndiosdf"
        self.actionStepLabel.text = "oisdhfo sdoifn osdf o sdfoin sdfo soidf soidfn sdfoisdfn osdif nsodfi  os ndiosdf soidfn sdfoisdfn osdi soidfn sdfoisdfn osdi soidfn sdfoisdfn osdi"
    }

}

// MARK: - CompassValidation

extension ActionPlanViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ActionPlanViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .actionplan
    }
}
