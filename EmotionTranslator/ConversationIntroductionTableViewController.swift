//
//  ConversationIntroductionTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ConversationIntroductionTableViewController: UITableViewController {
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var monsterLabel1: UILabel!
    @IBOutlet weak var monsterLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let monsterName = self.currentStressor.monsterName {
            
            let text = "\(monsterName) and you are going to have a conversation to find out what is’s trying to tell you."
            let attributedString = NSMutableAttributedString(string: text)
            let monsterRange = (text as NSString).range(of: monsterName)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: monsterRange)
            
            self.topLabel.attributedText = attributedString
            self.monsterLabel1.text = monsterName
            self.monsterLabel2.text = monsterName
        }
        
    }


}

// MARK: - CompassValidation

extension ConversationIntroductionTableViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ConversationIntroductionTableViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .introduction
    }
}



