//
//  CreateMonsterViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SectionCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionImageView: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var selectedLine: UIView!
    
    override var isSelected: Bool {
        didSet {
            self.selectedLine.isHidden = !isSelected
        }
    }
    
}

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    var monsterColor: UIColor?

    func setup() {
        if let color = self.monsterColor {
            self.imageContainerView.backgroundColor = color.withAlphaComponent(0.6)
        }
        else {
            self.imageContainerView.backgroundColor = .contentBackground
        }
    }
    
    private func addBorder() {
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.navBar.cgColor
        
        if let color = self.monsterColor {
            self.imageContainerView.backgroundColor = color.withAlphaComponent(0.6)
        }
        else {
            self.imageContainerView.backgroundColor = .white
        }
        
    }
    
    private func removeBorder() {
        
        self.contentView.layer.borderWidth = 0
        if let color = self.monsterColor {
            self.imageContainerView.backgroundColor = color.withAlphaComponent(0.6)
        }
        else {
            self.imageContainerView.backgroundColor = .contentBackground
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }

        }
    }
    
    
}

class CreateMonsterViewController: UIViewController {
    
    enum Section: Int {
        case color = 0
        case shape
        case eyes
        case mouth
        case hair
    }
    
    struct SectionItem {
        let title: String
        let image: UIImage
    }
    
    @IBOutlet weak var monsterView: MonsterView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var currentStressor: Stressor!
    
    fileprivate var sections: [SectionItem] = [SectionItem(title: "COLOR", image: #imageLiteral(resourceName: "color-section")),
                                               SectionItem(title: "SHAPE", image: #imageLiteral(resourceName: "shape-section")),
                                               SectionItem(title: "EYES", image: #imageLiteral(resourceName: "eyes-section")),
                                               SectionItem(title: "MOUTH", image: #imageLiteral(resourceName: "mouth-section")),
                                               SectionItem(title: "HAIR", image: #imageLiteral(resourceName: "hair-section")),]
    
    fileprivate typealias Color = Monster.Color
    
    fileprivate var currentSection: Section = .color
    
    fileprivate var currentColor: Color = .blue
    
    var gotoMonsterName: (() -> ())? = nil
    var questionsEnded: (() -> ())? = nil
    
    fileprivate var monster: Monster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.isSmallerThaniPhone6 {
            self.monsterView.scaleMonster(by: 0.7)
 
        }
        
        // pre select first position
        self.sectionCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.itemCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        if let monster = self.currentStressor.monster {
            self.monster = Monster(value: monster as Any)
        }
        
        
        if self.monster == nil {
            self.monster = Monster()
            self.monster?.color = Monster.Color.blue
            self.monster?.shape = Monster.Shape.heart
            self.monster?.eyes = Monster.Eyes.one
            self.monster?.mouth = Monster.Mouth.one
            self.monster?.hair = Monster.Hair.one
            Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.ownMonsterCreationStarted)
        }
        
        self.monsterView.monster = self.monster
        self.monsterView.setupMonster()
        
    }

    
    fileprivate func preselectItems() {
        
        guard let monster = self.monster else { return }
        
        var index = 0
        
        switch self.currentSection {
        case .color:
            index = monster.color.rawValue - 1
        case .shape:
            index = monster.shape.rawValue - 1
        case .eyes:
            index = monster.eyes.rawValue - 1
        case .mouth:
            index = monster.mouth.rawValue - 1
        case .hair:
            index = monster.hair.rawValue - 1
        }
        
        self.itemCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    fileprivate func itemImages(for section: Section, color:Monster.Color) -> [UIImage] {
        
        switch section {
        case .color:
            return Monster.Color.all.map { $0.image }
        case .shape:
            return Monster.Shape.all.map { $0.image(with: color) }
        case .eyes:
            return Monster.Eyes.all.map { $0.image }
        case .mouth:
            return Monster.Mouth.all.map { $0.image }
        case .hair:
            return Monster.Hair.all.map { $0.image(with: color) }
        }
        
    }

}

extension CreateMonsterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.sectionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell
            let section = self.sections[indexPath.row]
            cell.sectionLabel.text = section.title
            cell.sectionImageView.image = section.image
            return cell
        }
        // item cell
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let image = self.itemImages(for: self.currentSection, color: self.currentColor)[indexPath.row]
            
            switch self.currentSection {
            case .eyes, .mouth, .hair:
                cell.monsterColor = self.currentColor.color
            default:
                cell.monsterColor = nil
            }
            
            cell.itemImageView.image = image
            cell.setup()
            
            return cell
        }
        
    }
    
}

extension CreateMonsterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.sectionCollectionView {
            self.currentSection = Section(rawValue: indexPath.row)!
            self.titleLabel.text = self.sections[indexPath.row].title
            self.itemCollectionView.reloadData()
            self.preselectItems()
        }
        else {
            
            switch self.currentSection {
            case .color:
                self.currentColor = Color(rawValue: indexPath.row + 1)!
                self.monster?.color = self.currentColor
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.colorChanged)
            case .hair:
                self.monster?.hair = Monster.Hair(rawValue: indexPath.row + 1)!
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.hairChanged)
            case .eyes:
                self.monster?.eyes = Monster.Eyes(rawValue: indexPath.row + 1)!
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.eyesChanged)
            case .mouth:
                self.monster?.mouth = Monster.Mouth(rawValue: indexPath.row + 1)!
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.mouthChanged)
            case .shape:
                self.monster?.shape = Monster.Shape(rawValue: indexPath.row + 1)!
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.shapeChanged)
            }
            
            self.monsterView.setupMonster()
        }
    }
}

extension CreateMonsterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(self.sections.count), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - CompassValidation

extension CreateMonsterViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension CreateMonsterViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .create
        self.currentStressor.monster = self.monster
        self.currentStressor.hasCustomMonster = true
        Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.ownMonsterCreationFinished)
    }
}

