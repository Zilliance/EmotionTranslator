//
//  ConversationTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/7/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
}

class ResponseEntryCell: UITableViewCell {
    
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryTextView: KMPlaceholderTextView!
    
    override func awakeFromNib() {
        self.entryTextView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.entryTextView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.entryTextView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
}

extension ResponseEntryCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
}

class ResponseCell: UITableViewCell {
    
    @IBOutlet weak var responseLabel: UILabel!
    
}

class ConversationTableViewController: UITableViewController {
    
    struct QuestionAnswer {
        let question: String
        var answer: String
        
        var isCompleted: Bool {
            return !answer.isEmpty
        }
    }
    
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    
    private var elements: [QuestionAnswer] = [QuestionAnswer(question: "Question 1 goes here, room for a few lines of text…more copy here…then ends with a?", answer: "")]
    
    private var qaNumberOfElements: Int {
        return self.elements.filter {$0.isCompleted }.count * 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

    }

    func reply() {
        let 
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if self.qaNumberOfElements == 0 {
            return 2
        }
        else {
            return qaNumberOfElements + 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        
        if self.qaNumberOfElements == 0 {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            let qa = self.elements[indexPath.row]
            cell.questionLabel.text = qa.question
            cell.nameLabel.text = self.currentStressor.monsterName
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            return cell
          }
        }
        else {
            
            let qa = self.elements[indexPath.row/2 + 1]
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
                cell.nameLabel.text = self.currentStressor.monsterName
                cell.questionLabel.text = qa.question
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
                cell.responseLabel.text = qa.answer
                return cell
            }

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
