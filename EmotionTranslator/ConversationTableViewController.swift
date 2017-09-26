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
    @IBOutlet weak var questionNumberLabel: UILabel!
    
}

class ResponseEntryCell: UITableViewCell {
    
    @IBOutlet weak var entryTextView: KMPlaceholderTextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var reply: ((String) -> ())? = nil
    var update: ((String) -> ())? = nil
    
    override func awakeFromNib() {
        self.entryTextView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.entryTextView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.entryTextView.layer.borderColor = UIColor.silverColor.cgColor
        
    }
}

extension ResponseEntryCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            self.update?(textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if !textView.text.isEmpty {
                self.reply?(textView.text)
            }
            textView.resignFirstResponder()
        }
        return true
    }
    
}

class ResponseCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var responseLabel: UILabel!
    
}

enum ItemType {
    case question
    case answer
    case box
}

struct Item {
    var text: String
    var type: ItemType
}

struct Question {
    var text: String
    var number: Int
}

class ConversationTableViewController: UITableViewController {

    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    
    var questionsEnded: (() -> ())? = nil
    
    var questionsCompleted = false
    
    private var questions: [String] = []
    private var replies: [String] = []
    
    fileprivate var questionsAnswers: [QuestionAnswer] = []
    
    private var elements: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

        let currentConversation = Array(self.currentStressor.conversation)
        
        if !currentConversation.isEmpty {
            
            for element in currentConversation {
                if let question = element.question {
                    self.elements.append(Item(text: question, type: .answer))
                }
                else if let answer = element.answer {
                    self.elements.append(Item(text: answer, type: .answer))
                }
            }
        }
        
        self.insertReplyBox()
        self.reply()
    }
    
    private func insertReplyBox() {
         self.elements.append(Item(text: "", type: .box))
         self.tableView.insertRows(at: [IndexPath(item: self.elements.count - 1, section: 0)], with: .automatic)
        if elements.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:elements.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func prepareQuestions() {
        
        if let question = self.questions.first {
            self.elements.append(Item(text: question, type: .question))
            self.elements.append(Item(text: "", type: .box))
            self.questions.removeFirst()
            
            self.tableView.insertRows(at: [IndexPath(item: self.elements.count - 1, section: 0), IndexPath(item: self.elements.count - 2, section: 0)], with: .automatic)
            
            if elements.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:elements.count-1, section: 0), at: .bottom, animated: true)
            }
        }
        
        
    }
    
    private func insert(reply: String, indexPath: IndexPath) {
        
        let questionAnswer = QuestionAnswer()
        if indexPath.row % 2 == 0 {
            questionAnswer.question = reply
            
            Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.questionAdded)
            
        }
        else {
            questionAnswer.answer = reply
            
            Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.questionAnswered)

        }
        
        self.questionsAnswers.append(questionAnswer)
        
        self.elements.remove(at: indexPath.row)
        self.elements.insert(Item(text: reply, type: .answer), at: indexPath.row)
        self.replies.append(reply)
        if self.questions.count == 0 {
            self.questionsCompleted = true
            self.questionsEnded?()
            self.tableView.reloadRows(at: [IndexPath(item: self.elements.count - 1, section: 0)], with: .automatic)
        }
            
        else {
             self.tableView.reloadRows(at: [IndexPath(item: self.elements.count - 1, section: 0)], with: .automatic)
            self.prepareQuestions()
        }
    }
    

    func reply() {
        
        if elements.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:elements.count-1, section: 0), at: .bottom, animated: true)
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
            cell.questionNumberLabel.text = "Question \((indexPath.row + 1)/2 + 1)"
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
            
            if indexPath.row % 2 != 0 {
                cell.iconImageView.image = #imageLiteral(resourceName: "completed-stressor")
                cell.nameLabel.text = self.currentStressor.monster?.name
            }
            else {
                cell.iconImageView.image = #imageLiteral(resourceName: "user-conversation")
                cell.nameLabel.text = "Me"
            }
            
            cell.responseLabel.text = item.text
            return cell
            
        case .box:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            
            if indexPath.row % 2 != 0 {
                cell.iconImageView.image = #imageLiteral(resourceName: "completed-stressor")
                cell.nameLabel.text = self.currentStressor.monster?.name
            }
            else {
                cell.iconImageView.image = #imageLiteral(resourceName: "user-conversation")
                cell.nameLabel.text = "Me"
            }
            
            cell.reply = { [unowned self] text in
                self.insert(reply: text, indexPath: indexPath)
                self.insertReplyBox()
            }
            
            cell.entryTextView.text = ""
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
        
        self.currentStressor.lastEditedFacet = .conversation
        self.currentStressor.conversation.append(objectsIn: self.questionsAnswers)
    }
}
