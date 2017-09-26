//
//  TakeAwayViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

final class TakeAwayHeaderViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.73)
        self.selectionStyle = .none

    }
}

final class TakeAwayResponseViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.73)
        self.selectionStyle = .none

    }
}

final class TakeAwayQuestionViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: KMPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.textView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.color(forRed: 235, green: 235, blue: 235, alpha: 1).cgColor

        self.backgroundColor = UIColor.white.withAlphaComponent(0.73)
        self.selectionStyle = .none
        
        self.textView.placeholderFont = UIFont.muliLight(size: 14)

    }
    
}


class TakeAwayViewController: UITableViewController {
    
    var currentStressor: Stressor!
    var gotoIntroduction: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil
    
    var backgroundView: UIView!
    
    var takeAwayTextView: KMPlaceholderTextView?
    var takeAwayActionsTextView: KMPlaceholderTextView?
    var headerResized: Bool = false
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!self.headerResized) {
            self.headerResized = true
            let headerView = self.tableView.tableHeaderView
            headerView?.setNeedsLayout()
            headerView?.layoutIfNeeded()
            headerView?.frame.size = (self.tableView?.tableHeaderView?.systemLayoutSizeFitting(UILayoutFittingCompressedSize)) ?? CGSize(width: 0, height: 0)
            self.tableView.tableHeaderView = headerView
            
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var returnCell: UITableViewCell!
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! TakeAwayHeaderViewCell
            cell.label.text = section == 0 ? "Conversation" : "Take Action"
            returnCell = cell
            
        case (0, let row):
            let cell = tableView.dequeueReusableCell(withIdentifier: "response", for: indexPath) as! TakeAwayResponseViewCell
            cell.titleLabel.text = self.currentStressor.monster?.name
            
            switch row {
            case 1: cell.answerLabel.text = self.currentStressor.answer1
            case 2: cell.answerLabel.text = self.currentStressor.answer2
            case 3: cell.answerLabel.text = self.currentStressor.answer3
            case 4: cell.answerLabel.text = self.currentStressor.answer4
            default:
                break
            }
            returnCell = cell
            
        case (1, let row):
            let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath) as! TakeAwayQuestionViewCell
            
            switch row {
            case 1:
                cell.titleLabel.text = "Based on the convo you just had, what’s your biggest takeaway from this experience?"
                
                if (cell.textView.text.count == 0) {
                    cell.textView.text = self.currentStressor.takeAwayText
                }
                cell.textView.delegate = self
                cell.textView.placeholder = "My biggest takeaway is… example 1, example 2 "
                takeAwayTextView = cell.textView
            case 2:
                cell.titleLabel.text = "What action step does your takeaway inspire you to take?"
                
                if (cell.textView.text.count == 0) {
                    cell.textView.text = self.currentStressor.takeAwayActions
                }
                
                cell.textView.delegate = self
                cell.textView.placeholder = "I am inspired to… example 1, example 2 (hint text TBD)"
                takeAwayActionsTextView = cell.textView

            default:
                break
            }
            
            cell.contentView.backgroundColor = UIColor.clear
            
            returnCell = cell
            
        default:
            break
        }
        
        return returnCell
    }

}

// MARK: - CompassValidation

extension TakeAwayViewController: StressorValidation {
    var error: StressorError {
        return (takeAwayTextView?.text.trimmed.count ?? 0 > 0 && takeAwayActionsTextView?.text.trimmed.count ?? 0 > 0) ? .none : .text
    }
}

// MARK: - CompassFacetEditor

extension TakeAwayViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .takeaway
        self.currentStressor.takeAwayText = takeAwayTextView?.text
        self.currentStressor.takeAwayActions = takeAwayActionsTextView?.text
    }
}

extension TakeAwayViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
