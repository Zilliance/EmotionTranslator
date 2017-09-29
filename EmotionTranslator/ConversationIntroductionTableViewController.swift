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
    @IBOutlet weak var topLabelContainerView: UIView!
    @IBOutlet weak var monsterLabel1: UILabel!
    @IBOutlet weak var monsterLabel2: UILabel!
    @IBOutlet weak var userLabel1: UILabel!
    @IBOutlet weak var userLabel2: UILabel!
    
    @IBOutlet weak var userIcon1: UIImageView!
    @IBOutlet weak var userIcon2: UIImageView!
    @IBOutlet weak var monsterIcon1: UIImageView!
    @IBOutlet weak var monsterIcon2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Static table self-sizing cells
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 54;
        
        self.tableView.layer.contents = #imageLiteral(resourceName: "backgroundIntroduction").cgImage
        
        self.topLabelContainerView.backgroundColor = UIColor.silverColor.withAlphaComponent(0.8)
        self.topLabelContainerView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let filename = FileUtils.profileImagePath
        
        if let data = try? Data(contentsOf: filename) {
            let image = UIImage(data: data)
            self.userIcon1.setRound(image: image)
            self.userIcon2.setRound(image: image)
        }
        
        if let userName = Database.shared.user.name {
            if !userName.isEmpty {
                self.userLabel1.text = userName
                self.userLabel2.text = userName
            }
        }
        
        guard let monster = self.currentStressor.monster else { return }
        
        if let monsterName = monster.name {
            
            let text = "\(monsterName) and you are going to have a conversation to find out what is’s trying to tell you."
            let attributedString = NSMutableAttributedString(string: text)
            let monsterRange = (text as NSString).range(of: monsterName)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 12), range: monsterRange)
            
            self.topLabel.attributedText = attributedString
            self.monsterLabel1.text = monsterName
            self.monsterLabel2.text = monsterName
            
            self.monsterIcon1.image = monster.shape.image(with: monster.color)
            self.monsterIcon2.image = monster.shape.image(with: monster.color)
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



