//
//  Conversation2TableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/18/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class Conversation2TableViewController: UITableViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    
    var questionsEnded: (() -> ())? = nil
    
    
    private var questions = ["What’s the main message you’re trying to give me?",
                             "How have you been trying to help me?",
                             "What do you need to feel better?",
                             "What is an action step you wish I would take?",
                             ]
    
    private var placeholders = ["My main message to you is...",
                                 "I’m trying to help...",
                                 "What I need to feel better is...",
                                 "I wish you would…",
                                 ]
    
    fileprivate var replies: [String] = ["" ,"" ,"" ,"" ,]
    
    private var elements: [Item] = []
    
    var questionsCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        if let monsterName = self.currentStressor.monsterName {
            
            let text = "Before you finish, take one more minute to ask \(monsterName) the following 4 questions:"
            let attributedString = NSMutableAttributedString(string: text)
            let monsterRange = (text as NSString).range(of: monsterName)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: monsterRange)
            
            self.headerLabel.attributedText = attributedString
        }
        
        self.prepareQuestions()

    }

    
    private func prepareQuestions() {
        
        if let question = self.questions.first , let placeholder = self.placeholders.first {
            self.elements.append(Item(text: question, type: .question))
            self.elements.append(Item(text: placeholder, type: .box))
            self.questions.removeFirst()
            self.placeholders.removeFirst()
            
            self.tableView.insertRows(at: [IndexPath(item: self.elements.count - 1, section: 0), IndexPath(item: self.elements.count - 2, section: 0)], with: .automatic)
            
            if elements.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:elements.count-1, section: 0), at: .bottom, animated: true)
            }
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.elements[indexPath.row]
        
        switch item.type {
        case .question:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            cell.questionLabel.text = item.text
            cell.questionNumberLabel.text = "Question \((indexPath.row + 1)/2 + 1)"
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
            cell.responseLabel.text = item.text
            return cell
            
        case .box:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            
            
            let text = self.replies[(indexPath.row)/2]
            
            cell.nameLabel.text = self.currentStressor.monsterName
            
            cell.entryTextView.text = ""
            
            if !text.isEmpty {
                cell.entryTextView.text = text
            }
            else {
                cell.entryTextView.placeholder = item.text
            }
            
            cell.reply = { [unowned self] text in
                self.replies[indexPath.row/2] = text
                self.prepareQuestions()
                let finished = self.replies.filter { $0.isEmpty }.count == 0
                if finished {
                    self.questionsEnded?()
                }
            }
            
            cell.update = { [unowned self] text in
                self.replies[indexPath.row/2] = text
                tableView.reloadData()
            }
            
            return cell
        }
    }

}

// MARK: - CompassValidation

extension Conversation2TableViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension Conversation2TableViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .conversation2
    }
}
