//
//  EmotionViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {

    private(set) var tableViewController: ItemsSelectionViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    var currentStressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewController.updateItems(newItems: Array(Database.shared.emotionsStored))
        //scroll table to top
        self.tableViewController.tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    private func setupView() {
        self.containerView.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.containerView.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.containerView.layer.borderColor = UIConstants.Color.lightGray.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemsSelectionsController = segue.destination as? ItemsSelectionViewController {
            
            itemsSelectionsController.type = Emotion.self
            self.tableViewController = itemsSelectionsController
            
            itemsSelectionsController.items = Array(Database.shared.emotionsStored)
            itemsSelectionsController.selectedItems = Array(self.currentStressor.emotions)
            
            itemsSelectionsController.saveAction = { selectedItems in
                
                let items = selectedItems.flatMap {
                    return $0 as? Emotion
                }
                
                Database.shared.save {
                    self.currentStressor.emotions.removeAll()
                    self.currentStressor.emotions.append(objectsIn: items)
                }
            }
            
            itemsSelectionsController.deleteAction = {[unowned self] toDeleteItem in
                
                guard let item = toDeleteItem as? Emotion else {
                    return assertionFailure()
                }
                
                Database.shared.save {
                    if let index = self.currentStressor.emotions.index(of: item) {
                        self.currentStressor.emotions.remove(objectAtIndex: index)
                    }
                }
                
                Database.shared.delete(item)
                
            }
        }
    }
    

}

// MARK: - CompassValidation

extension EmotionViewController: StressorValidation {
    var error: StressorError {
        if let items = self.tableViewController?.selectedItems, items.count > 0 {
            return .none
        } else {
            return .selection
        }
    }
}

// MARK: - CompassFacetEditor

extension EmotionViewController: StressorFacetEditor {
    func save() {
        self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .emotion
    }
}

