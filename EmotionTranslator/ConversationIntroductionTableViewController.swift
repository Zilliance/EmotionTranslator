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
    var questionsEnded: (() -> ())? = nil

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var monsterLabel1: UILabel!
    @IBOutlet weak var monsterLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Static table self-sizing cells
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 54;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func learnMore(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("learn more conversation introduction", comment: ""), size: .large)
    }
}

// MARK: - UITableViewDelegate

extension ConversationIntroductionTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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



