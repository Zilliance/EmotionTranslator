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
    
    func setup(for emotionTranslator: EmotionTranslator) {
        
        self.titleLabel.text = emotionTranslator.stressor
        
        self.completedLabel.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.completedLabel.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        
        if emotionTranslator.completed {
            self.completedLabel.backgroundColor = .navBar
            self.completedLabel.textColor = .white
            self.completedLabel.text = EmotionTranslatorCollectionViewCell.dateFormatter.string(from: emotionTranslator.dateCreated)
            self.completedLabel.layer.borderColor = UIColor.navBar.cgColor
            
        }
            
        else {
            self.completedLabel.backgroundColor = .contentBackground
            self.completedLabel.textColor = .darkBlue
            self.completedLabel.text = "In progress"
            self.completedLabel.layer.borderColor = UIColor.navBar.cgColor
            
        }
    }
    
}

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isDeleting = false
    
    fileprivate var emotionTranslators: [EmotionTranslator] {
        return []
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
        
        guard self.emotionTranslators.count > 0 else {
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
                        
                        return self.emotionTranslators[index.row]
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
        return self.emotionTranslators.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmotionTranslatorCollectionViewCell
        
        // Configure the cell
        let emotionTranslator = self.emotionTranslators[indexPath.row]
        cell.isDeleting = self.isDeleting
        cell.setup(for: emotionTranslator)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard !self.isDeleting else {
//            return
//        }
//        
//        let stressor = self.stressors[indexPath.row]
//        guard let vc = UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateInitialViewController() as? SummaryViewController else {
//            assertionFailure()
//            return
//        }
//        // pass stressor copy
//        vc.stressor = Stressor(value: stressor)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 40, height: 90)
    }
    
}
