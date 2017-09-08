//
//  ConversationTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/7/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
}

class ResponseEntryCell: UITableViewCell {
    
    @IBOutlet weak var entryTextView: KMPlaceholderTextView!
    
    var reply: ((String) -> ())? = nil
    
    override func awakeFromNib() {
        self.entryTextView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.entryTextView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.entryTextView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
}

extension ResponseEntryCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n" && !textView.text.isEmpty) {
           self.reply?(textView.text)
           textView.resignFirstResponder()
        }
        return true
    }
    
}

class ResponseCell: UITableViewCell {
    
    @IBOutlet weak var responseLabel: UILabel!
    
}

class ConversationTableViewController: UITableViewController {
    
    enum ItemType {
        case question
        case answer
        case box
    }
    
    struct Item {
        var text: String
        var type: ItemType
    }
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    
    var questionsEnded: (() -> ())? = nil
    
    var questionsCompleted = false
    
    private var elements: [Item] = [Item(text: "Question 1 goes here, room for a few lines of text…more copy here…then ends with a?", type: .question),Item(text: "", type: .box)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

    }

    func reply() {
        
        if elements.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:elements.count-1, section: 0), at: .bottom, animated: false)
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath(item: elements.count-1, section: 0)) as? ResponseEntryCell {
            cell.entryTextView.becomeFirstResponder()
        }
            
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.elements.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        
        let item = self.elements[indexPath.row]
        
        switch item.type {
        case .question:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            cell.questionLabel.text = item.text
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
            cell.responseLabel.text = item.text
            return cell
            
        case .box:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            cell.reply = { [unowned self] text in
                
                self.elements.remove(at: indexPath.row)
                self.elements.insert(Item(text: text, type: .answer), at: indexPath.row)
                self.questionsCompleted = true
                self.questionsEnded?()
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
}

// MARK: - CompassValidation

extension ConversationTableViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ConversationTableViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .conversation
    }
}
