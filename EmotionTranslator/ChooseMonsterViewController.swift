//
//  ChooseMonsterViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/31/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ChooseMonsterViewController: UIViewController {
    
    var currentStressor: Stressor!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - CompassValidation

extension ChooseMonsterViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ChooseMonsterViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .monster
    }
}
