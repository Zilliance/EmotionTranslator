//
//  NewStressorViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/29/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class NewStressorViewController: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var counterLabel: UILabel!
    
    fileprivate let maxTextlenght = 48
    
    var currentStressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.counterLabel.isHidden = true
    }
    
    private func setupView() {
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.textView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.textView.layer.borderColor = UIConstants.Color.lightGray.cgColor
    }

}

// MARK: - CompassValidation

extension NewStressorViewController: StressorValidation {
    var error: StressorError {
        if self.textView.text.isEmpty {
            return .text
        } else {
            return .none
        }
    }
}

// MARK: - CompassFacetEditor

extension NewStressorViewController: StressorFacetEditor {
    func save() {
        self.currentStressor.title = self.textView.text
        self.currentStressor.lastEditedFacet = .stressor
    }
}

extension NewStressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        // check max character lenght
        
        let charCount = textView.text.characters.count + (text.characters.count - range.length)
        
        self.counterLabel.isHidden = charCount == 0
        self.counterLabel.text = "\(maxTextlenght - textView.text.characters.count)"
        
        return charCount <= maxTextlenght
        
    }
}
