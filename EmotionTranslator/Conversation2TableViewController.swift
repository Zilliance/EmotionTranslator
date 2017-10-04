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
    @IBOutlet weak var headerContainer: UIView!
    
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
    
    fileprivate var replies: [String?] = [nil ,nil ,nil ,nil ,]
    
    private var elements: [Item] = []
    
    var questionsCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.tableView.layer.contentsGravity = kCAGravityResizeAspectFill
        self.tableView.layer.contents = #imageLiteral(resourceName: "generalBackground").cgImage
        
        self.headerContainer.backgroundColor = UIColor.contentBackground
        self.headerContainer.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        
        self.prepareReplies()
        
    }

    private func prepareReplies() {
        
        self.replies[0] = self.currentStressor.answer1
        self.replies[1] = self.currentStressor.answer2
        self.replies[2] = self.currentStressor.answer3
        self.replies[3] = self.currentStressor.answer4
        
        // prefill questions - answers
        
        for reply in self.replies {
            
            guard let _ = reply else { break }
            self.prepareQuestions()
        }
        
        self.checkIfQuestionsAreFinished()
        
        if self.elements.isEmpty {
            self.prepareQuestions()
        }
    }
    
    private func checkIfQuestionsAreFinished() {
        let finished = self.replies.flatMap { $0 }.count != 0
        if finished {
            self.questionsCompleted = true
            self.questionsEnded?()
        }
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
            
            cell.questionLabel.text = item.text
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as! ResponseCell
            cell.responseLabel.text = item.text
            return cell
            
        case .box:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseEntryCell", for: indexPath) as! ResponseEntryCell
            
            
            let text = self.replies[(indexPath.row)/2]
            
            if let monster = self.currentStressor.monster {
                cell.iconImageView.image = monster.shape.image(with: monster.color)
                cell.nameLabel.text = monster.name
            }
            
            cell.entryTextView.text = ""
            
            if let text = text {
                cell.entryTextView.text = text
                cell.skipButton.isHidden = true
            }
            else {
                cell.entryTextView.placeholder = item.text
                if indexPath.row + 1 == tableView.numberOfRows(inSection: 0) {
                    cell.skipButton.isHidden = false
                }
                else {
                    cell.skipButton.isHidden = true
                }
            }
            
            cell.reply = { [unowned self] text in
            
                let cells = tableView.visibleCells
                
                for cell in cells {
                    if let responseCell = cell as? ResponseEntryCell {
                        responseCell.skipButton.isHidden = true
                    }
                }
                
                self.replies[indexPath.row/2] = text
                
                if tableView.numberOfRows(inSection: 0) == indexPath.row + 1 {
                    self.prepareQuestions()
                }
                
              self.checkIfQuestionsAreFinished()
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
        self.currentStressor.answer1 = self.replies[0]
        self.currentStressor.answer2 = self.replies[1]
        self.currentStressor.answer3 = self.replies[2]
        self.currentStressor.answer4 = self.replies[3]
    }
}
