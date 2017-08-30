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
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
            //cell.addButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StringItemSelectionCell", for: indexPath) as! StringItemSelectionCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel?.text = item.title
        
        cell.selectionImage.image = selectedItems.contains(item) ? UIImage(named: "checkbox-checked"): UIImage(named: "checkbox-unchecked")
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
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
        return indexPath.section == 1
    }
    
}


