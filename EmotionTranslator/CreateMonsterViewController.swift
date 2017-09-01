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
    
}

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
}

class CreateMonsterViewController: UIViewController {
    
    enum Section: String {
        case color
        case shape
        case eyes
        case mouth
        case hair
    }
    
    struct SectionItem {
        let title: String
        let image: UIImage
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    //Monster
    @IBOutlet weak var shapeImageView: UIImageView!
    @IBOutlet weak var hairImageView: UIImageView!
    @IBOutlet weak var eyesImageView: UIImageView!
    @IBOutlet weak var mouthImageView: UIImageView!
    
    fileprivate var sections: [SectionItem] = [SectionItem(title: "COLOR", image: #imageLiteral(resourceName: "eyes-3")),
                                               SectionItem(title: "SHAPE", image: #imageLiteral(resourceName: "eyes-3")),
                                               SectionItem(title: "EYES", image: #imageLiteral(resourceName: "eyes-3")),
                                               SectionItem(title: "MOUTH", image: #imageLiteral(resourceName: "eyes-3")),
                                               SectionItem(title: "ITEM", image: #imageLiteral(resourceName: "eyes-3")),]
    
    fileprivate typealias Color = Monster.Color
    
    fileprivate var currentSection: Section = .color
    
    fileprivate var currentColor: Color = .blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            cell.itemImageView.image = image
            return cell
        }
        
    }
    
}

extension CreateMonsterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(self.sections.count), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

