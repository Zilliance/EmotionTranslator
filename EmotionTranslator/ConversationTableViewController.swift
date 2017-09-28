//
//  ConversationTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/7/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import MZFormSheetController

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
}

class ResponseEntryCell: UITableViewCell {
    
    @IBOutlet weak var entryTextView: KMPlaceholderTextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    
    var reply: ((String) -> ())? = nil
    var update: ((String) -> ())? = nil
    
    override func awakeFromNib() {
        self.entryTextView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.entryTextView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.entryTextView.layer.borderColor = UIColor.silverColor.cgColor
        
    }
    @IBAction func skipAction(_ sender: Any) {
        self.reply?("")
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

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
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
        
        self.timerButton.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.timerButton.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.timerButton.layer.borderColor = UIColor.thinkGreen.cgColor
        
        self.timerButton.backgroundColor = UIColor.thinkGreen
        
        self.timerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.timerView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        
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
    
    fileprivate func changeButtonBackground(for timer:Timer) {
        if timer.isValid {
            self.timerButton.backgroundColor = .white
            self.timerButton.setTitleColor(.thinkGreen, for: .normal)
        } else {
            self.timerButton.backgroundColor = .thinkGreen
            self.timerButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func timerAction(_ sender: Any) {
        self.startTimer()
    }
    
    @IBAction func exampleAction(_ sender: Any) {
        
        guard let exampleViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "Example") as? ConversationExampleTableViewController else {
            assertionFailure()
            return
        }
        
        let formSheet = MZFormSheetController(viewController: exampleViewController)
        formSheet.shouldDismissOnBackgroundViewTap = true
        formSheet.presentedFormSheetSize = CGSize(width: self.view.bounds.width - 20, height: self.view.bounds.height + 25)
        formSheet.shouldCenterVertically = true
        formSheet.transitionStyle = .slideFromBottom
        
        self.mz_present(formSheet, animated: true, completionHandler: nil)
    }
    
    override var analyticsObjectName: String {
        return "Conversation 1"
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

// MARK: - TIMER

extension ConversationTableViewController {
    
    // https://teamtreehouse.com/community/swift-countdown-timer-of-60-seconds
    
    func startTimer() {
        
        guard let timer = self.countdownTimer
            else {
                self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                self.changeButtonBackground(for: self.countdownTimer)
                self.updateTime()
                return
                
        }
        
        if !timer.isValid {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        else {
            self.countdownTimer.invalidate()
        }
        
        self.changeButtonBackground(for: self.countdownTimer)
    }
    
    func updateTime() {
        
        self.timerButton.setTitle("\(self.timeFormatted(totalTime))", for: .normal)
        
        if self.totalTime != 0 {
            self.totalTime -= 1
        } else {
            self.endTimer()
        }
    }
    
    func endTimer() {
        self.countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
