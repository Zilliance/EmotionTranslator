//
//  ConversationExampleTableViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ConversationExampleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
    }

    @IBAction func closeAction(_ sender: Any) {
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
    }
}
