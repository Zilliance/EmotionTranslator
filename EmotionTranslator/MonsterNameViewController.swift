//
//  MonsterNameViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/5/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class MonsterNameViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var monsterView: MonsterView!
    
    var currentStressor: Stressor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.isSmallerThaniPhone6 {
            self.monsterView.scaleMonster(by: 0.7)
            
        }
        
        self.monsterView.monster = self.currentStressor.monster
        self.monsterView.setupMonster()

    }

}


// MARK: - CompassValidation

extension MonsterNameViewController: StressorValidation {
    var error: StressorError {
        
        if let text = self.nameTextField.text {
            if text.isEmpty {
                return .text
            }
            else {
                return .none
            }
        }
        return .text
    }
}

// MARK: - CompassFacetEditor

extension MonsterNameViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .name
        self.currentStressor.monsterName = self.nameTextField.text
    }
}
