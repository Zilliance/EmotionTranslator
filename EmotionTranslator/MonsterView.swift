//
//  MonsterView.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class MonsterView: UIView {
    
    @IBOutlet var contentView: MonsterView!
    
    //Monster
    @IBOutlet weak var shapeImageView: UIImageView!
    @IBOutlet weak var hairImageView: UIImageView!
    @IBOutlet weak var eyesImageView: UIImageView!
    @IBOutlet weak var mouthImageView: UIImageView!
    
    @IBOutlet weak var hairHeight: NSLayoutConstraint!
    @IBOutlet weak var hairWidth: NSLayoutConstraint!
    @IBOutlet weak var eyesWidth: NSLayoutConstraint!
    @IBOutlet weak var eyesHeight: NSLayoutConstraint!
    @IBOutlet weak var mouthWidth: NSLayoutConstraint!
    @IBOutlet weak var mouthHeight: NSLayoutConstraint!
    
    var monster: Monster?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.commonInit()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {

        Bundle.main.loadNibNamed("MonsterView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        
    }

    fileprivate func setupMonster() {

        if let monster = self.monster {
            self.shapeImageView.image = monster.shape.image(with: monster.color)
            self.hairImageView.image = monster.hair.image(with: monster.color)
            self.eyesImageView.image = monster.eyes.image
            self.mouthImageView.image = monster.mouth.image
        }
    }
    
    fileprivate func scaleMonster(by factor: CGFloat) {
        
        for constraint in [self.eyesWidth, self.eyesHeight, self.mouthHeight, self.mouthWidth, self.hairWidth, self.hairHeight] {
            
            if let c = constraint {
                c.constant = c.constant * factor
            }
        }
        
    }
}
