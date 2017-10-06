//
//  CompletedConversationTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 10/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CompletedConversationTableViewController: UITableViewController {
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    
    var questionsEnded: (() -> ())? = nil
    
    var questionsCompleted = true
    
    private var questions: [String] = []
    private var replies: [String] = []
    
    var countdownTimer: Timer!
    var totalTime = 60 * 3
    
    var headerResized = false
    
    fileprivate var questionsAnswers: [QuestionAnswer] = []
    
    private var elements: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.tableView.layer.contentsGravity = kCAGravityResizeAspectFill
        self.tableView.layer.contents = #imageLiteral(resourceName: "generalBackground").cgImage
        
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
        
        self.reply()
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
    
    
    override var analyticsObjectName: String {
        return "Cnmpleted Conversation"
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
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
            
            if indexPath.row % 2 != 0 {
                
                if let monster = self.currentStressor.monster {
                    cell.iconImageView.image = monster.shape.image(with: monster.color)
                }
                
            }
            else {
                let filename = FileUtils.profileImagePath
                
                if let data = try? Data(contentsOf: filename) {
                    let image = UIImage(data: data)
                    cell.iconImageView.setRound(image: image)
                }
                else {
                    cell.iconImageView.image = #imageLiteral(resourceName: "user-conversation")
                }
            }
            
            cell.responseLabel.text = item.text
            return cell
            
        case .box:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            
            if indexPath.row % 2 != 0 {
                if let monster = self.currentStressor.monster {
                    cell.iconImageView.image = monster.shape.image(with: monster.color)
                    cell.nameLabel.text = monster.name
                }
            }
            else {
                
                let filename = FileUtils.profileImagePath
                
                if let data = try? Data(contentsOf: filename) {
                    let image = UIImage(data: data)
                    cell.iconImageView.setRound(image: image)
                }
                else {
                    cell.iconImageView.image = #imageLiteral(resourceName: "user-conversation")
                }
                
                if let userName = Database.shared.user.name {
                    if !userName.isEmpty {
                        cell.nameLabel.text = userName
                    }
                }
                else {
                    
                    cell.nameLabel.text = "Me"
                }
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

extension CompletedConversationTableViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension CompletedConversationTableViewController: StressorFacetEditor {
    func save() {
        
//        self.currentStressor.lastEditedFacet = .conversation
//        self.currentStressor.conversation.append(objectsIn: self.questionsAnswers)
    }
}

