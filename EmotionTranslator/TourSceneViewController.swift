//
//  TourSceneViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 8/23/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class TourSceneViewController: UIViewController {
    @IBOutlet weak var divider: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.divider.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        self.divider.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.divider.layer.shadowRadius = 1.0
        self.divider.layer.shadowOpacity = 0.4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
