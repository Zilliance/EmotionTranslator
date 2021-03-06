//
//  HomeViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared

class HomeViewController: UIViewController {

    @IBOutlet weak var topOverlay: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var seeActionPlanButton: UIButton!
    @IBOutlet weak var actionPlanButtonContainerView: UIView!
    
    private var collectionViewController: HomeCollectionViewController!
    
    fileprivate var isDeleting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Emotion Translator"
        self.editButton.title = "Edit"
        self.startButton.imageView?.contentMode = .scaleAspectFit
        self.startButton.titleLabel?.font = UIFont.muliRegular(size: UIDevice.isSmallerThaniPhone6 ? 14 : 18)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionViewController.collectionView?.reloadData()
    }
    
    
    private func toogleDeleteMode() {
        
        self.isDeleting = !self.isDeleting
        self.collectionViewController.isDeleting = self.isDeleting
        self.collectionViewController.collectionView?.reloadData()
        self.editButton.title = self.isDeleting ? "Done" : "Edit"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topOverlay.alpha = self.isDeleting ? 0.6 : 0
            self.deleteButton.alpha = self.isDeleting ? 1 : 0
            self.selectLabel.alpha = self.isDeleting ? 1 : 0
            self.seeActionPlanButton.alpha = self.isDeleting ? 0 : 1
            self.actionPlanButtonContainerView.alpha = self.isDeleting ? 0 : 1
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? HomeCollectionViewController {
            self.collectionViewController = collectionViewController
        }
        
    }
    
    // MARK: - User Action
    
    @IBAction func showActionPlan(_ sender: Any) {
        let bundle = ZillianceSharedBundle.resourcesBundle
        
        guard let planVC = UIStoryboard(name: "Plan", bundle: bundle).instantiateViewController(withIdentifier: "ActionPlanViewController") as? ActionPlanViewController else{
            assertionFailure()
            return
        }
        let navigation = OrientableNavigationController(rootViewController: planVC)
        
        self.present(navigation, animated: true)
    }
    
    @IBAction func menuAction(_ sender: UIBarButtonItem) {
        self.sideMenuController?.toggle()
    }
    
    @IBAction func edit(_ sender: Any?) {
        self.toogleDeleteMode()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.collectionViewController.delete()
    }

}
