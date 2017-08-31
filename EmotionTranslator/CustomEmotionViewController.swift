//
//  CustomEmotionViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/31/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

import UIKit
import KMPlaceholderTextView

protocol CustomEmotionViewControllerDelegate: class {
    func newItemSaved(newItem: StringItem)
}

final class CustomEmotionViewController: UIViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var type: StringItem.Type!
    weak var delegate: CustomEmotionViewControllerDelegate!
    
    
    fileprivate let placeholderTextColor = UIColor.lightGray
    fileprivate let normalTextColor = UIColor.darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.becomeFirstResponder()
    }
    
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeView))
        
        self.textView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.textView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension CustomEmotionViewController {
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        
        guard self.textView.text.characters.count > 0 else {
            self.showAlert(title: "Please enter text", message: "")
            textView.becomeFirstResponder()
            return
        }
        
        let newItem = self.type.createNew(title: textView.text)
        self.delegate.newItemSaved(newItem: newItem)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CustomEmotionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.save()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
