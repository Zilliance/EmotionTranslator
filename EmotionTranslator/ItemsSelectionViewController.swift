//
//  ItemsSelectionViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 17-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

final class ItemsSelectionViewController: UITableViewController {
    
    var items: [StringItem] = []
    var selectedItems: [StringItem] = []
    var saveAction: (([StringItem]) -> ())!
    var deleteAction: ((StringItem) -> ())?
    
    var type : StringItem.Type!
    
    private enum Sections: Int {
        case emotions = 0
        case other
        case count
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Sections.emotions.rawValue ? self.items.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == Sections.other.rawValue) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
            cell.addButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StringItemSelectionCell", for: indexPath) as! StringItemSelectionCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel?.text = item.title
        
        cell.selectionImage.image = selectedItems.contains(item) ? UIImage(named: "checkbox-checked"): UIImage(named: "checkbox-unchecked")
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Sections.emotions.rawValue else {
            return
        }
        
        let item = items[indexPath.row]
        let index = selectedItems.index(of: item)
        if let index = index {
            selectedItems.remove(at: index)
        }
        else {
            selectedItems.append(item)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateItems(newItems: [StringItem]) {
        self.items = newItems
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{[unowned self] action, indexpath in
            
            let item = self.items[indexPath.row]
            
            if let selectedIndex = self.selectedItems.index(of: item) {
                self.selectedItems.remove(at: selectedIndex)
            }
            
            self.items.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.deleteAction?(item)
        });
        
        return [deleteRowAction];
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Sections.emotions.rawValue
    }
    
}

extension ItemsSelectionViewController: CustomEmotionViewControllerDelegate {
    
    //add a new item logic
    @objc fileprivate func addItemTapped() {
        
        guard let customEmotionViewController = UIStoryboard(name: "Emotion", bundle: nil).instantiateViewController(withIdentifier: "CustomEmotion") as? CustomEmotionViewController
            else {
                assertionFailure()
                return
        }
        
        customEmotionViewController.type = self.type
        customEmotionViewController.delegate = self

        let navController = OrientableNavigationController(rootViewController: customEmotionViewController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func newItemSaved(newItem: StringItem) {
        
        self.selectedItems.append(newItem)
        
    }
    
}

