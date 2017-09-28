//
//  HomeCollectionViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EmotionTranslatorCell"

class EmotionTranslatorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    
    var isDeleting = false
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override var isSelected: Bool {
        didSet {
            guard isDeleting else {
                return
            }
            if isSelected {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }
        }
    }
    
    private func addBorder() {
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.aquaBlue.cgColor
        self.checkmarkView.alpha = 1
        
    }
    
    private func removeBorder() {
        
        self.contentView.layer.borderWidth = 0
        self.checkmarkView.alpha = 0
        
    }
    
    func setup(for stressor: Stressor) {
        
        self.titleLabel.text = stressor.title
        
        self.completedLabel.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.completedLabel.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        
        guard let monster = stressor.monster else { return }
        
        if stressor.completed {
            self.completedLabel.backgroundColor = monster.color.color
            self.completedLabel.textColor = .white
            self.completedLabel.text = EmotionTranslatorCollectionViewCell.dateFormatter.string(from: stressor.dateCreated)
            self.completedLabel.layer.borderColor = UIColor.clear.cgColor
            self.icon.image = monster.shape.image(with: monster.color)
            
        }
            
        else {
            self.completedLabel.backgroundColor = .contentBackground
            self.completedLabel.textColor = .darkBlue
            self.completedLabel.text = "In progress"
            self.completedLabel.layer.borderColor = UIColor.navBar.cgColor
            self.icon.image = monster.shape.image(with: monster.color)
            
        }
        
    }
    
}

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isDeleting = false
    
    fileprivate var stressors: [Stressor] {
        return Array(Database.shared.user.stressors)
    }
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .paleGrey
        self.collectionView?.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    func delete() {
        
        guard self.stressors.count > 0 else {
            return
        }
        
        if let indexes = self.collectionView?.indexPathsForSelectedItems, indexes.count > 0 {
            
            let alertController = UIAlertController(title: "Are you sure you want to delete the selected emotion translators?", message: "Deleting them will permanently remove them.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                alertController.dismiss(animated: true, completion: nil)
                
                self.collectionView?.performBatchUpdates({
                    
                    let emotionTranslators = indexes.map { [unowned self] index in
                        
                        return self.stressors[index.row]
                    }
                    
                    for emotionTranslator in emotionTranslators {
                        Database.shared.delete(emotionTranslator)
                    }
                    
                    self.collectionView?.deleteItems(at: indexes)
                }, completion: nil)
                
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.showAlert(title: "Please select the emotion translator you would like to delete", message: nil)
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stressors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmotionTranslatorCollectionViewCell
        
        // Configure the cell
        let emotionTranslator = self.stressors[indexPath.row]
        cell.isDeleting = self.isDeleting
        cell.setup(for: emotionTranslator)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !self.isDeleting else {
            return
        }
        
        let stressor = self.stressors[indexPath.row]
        
        if !stressor.completed {
            guard let createStressorViewController = UIStoryboard(name: "CreateStressor", bundle: nil).instantiateInitialViewController() as? CreateStressorViewController else { return }
            createStressorViewController.stressor = stressor.detached()
            self.navigationController?.pushViewController(createStressorViewController, animated: true)
            
        }
            
        else {
            guard let actionPlanViewController = UIStoryboard(name: "Actionplan", bundle: nil).instantiateInitialViewController() as? ActionViewController else { return assertionFailure() }
            
            actionPlanViewController.currentStressor = stressor
            actionPlanViewController.isStressorCompleted = true
            actionPlanViewController.view.layer.contents = #imageLiteral(resourceName: "backgroundActionPlan").cgImage
            actionPlanViewController.view.layer.contentsGravity = kCAGravityResizeAspectFill
            self.navigationController?.pushViewController(actionPlanViewController, animated: true)
            
        }
        

    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 40, height: 90)
    }
    
}
