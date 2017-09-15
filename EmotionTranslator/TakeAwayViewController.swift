//
//  TakeAwayViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class TakeAwayViewController: UIViewController {
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

// MARK: - CompassValidation

extension TakeAwayViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension TakeAwayViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .takeaway
    }
}
