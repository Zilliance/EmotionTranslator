//
//  TimerViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/22/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var countdownTimer: Timer!
    var totalTime = 60 * 3
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil
    
    fileprivate var conversationViewController: ConversationTableViewController!

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.timerButton.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.timerButton.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.timerButton.layer.borderColor = UIColor.thinkGreen.cgColor
        
        self.timerButton.backgroundColor = UIColor.thinkGreen
    }

    private func setupView() {
        self.timerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        if let monsterName = self.currentStressor.monsterName {
            
            let text = "\(monsterName) and you are going to have a conversation to find out what is’s trying to tell you."
            let attributedString = NSMutableAttributedString(string: text)
            let monsterRange = (text as NSString).range(of: monsterName)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 16), range: monsterRange)
            
            self.topLabel.attributedText = attributedString
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.conversationViewController = segue.destination as! ConversationTableViewController
        self.conversationViewController.currentStressor = self.currentStressor
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
}

// MARK: - CompassValidation

extension TimerViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension TimerViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .conversation
    }
}

// MARK: - TIMER

extension TimerViewController {
    
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


