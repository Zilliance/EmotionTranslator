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
    
    var currentStressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
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
        
        return true
    }
}
