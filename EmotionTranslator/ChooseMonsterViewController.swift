//
//  ChooseMonsterViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/31/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ChooseMonsterViewController: UIViewController {
    
    var currentStressor: Stressor!
    var gotoMonsterName: (() -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK -- User Actions
    
    @IBAction func character1Action(_ sender: Any) {
        self.storeMonster(with: Monster.Default(color: Monster.Color.red, shape: Monster.Shape.square, hair: Monster.Hair.five, mouth: Monster.Mouth.two, eyes: Monster.Eyes.one))
    }
    
    @IBAction func character5Action(_ sender: Any) {
        self.storeMonster(with: Monster.Default(color: Monster.Color.purple, shape: Monster.Shape.oval, hair: Monster.Hair.three, mouth: Monster.Mouth.one, eyes: Monster.Eyes.two))
    }
    
    @IBAction func character3Action(_ sender: Any) {
        self.storeMonster(with: Monster.Default(color: Monster.Color.blue, shape: Monster.Shape.triangle, hair: Monster.Hair.four, mouth: Monster.Mouth.three, eyes: Monster.Eyes.five))
    }
    
    @IBAction func character4Action(_ sender: Any) {
        self.storeMonster(with: Monster.Default(color: Monster.Color.green, shape: Monster.Shape.pointed, hair: Monster.Hair.two, mouth: Monster.Mouth.five, eyes: Monster.Eyes.four))
    }
    
    @IBAction func character2Action(_ sender: Any) {
        self.storeMonster(with: Monster.Default(color: Monster.Color.yellow, shape: Monster.Shape.heart, hair: Monster.Hair.one, mouth: Monster.Mouth.four, eyes: Monster.Eyes.three))
    }
    
    private func storeMonster(with monsterDefault:Monster.Default) {
        let monster = Monster()
        monster.color = monsterDefault.color
        monster.shape = monsterDefault.shape
        monster.hair = monsterDefault.hair
        monster.mouth = monsterDefault.mouth
        monster.eyes = monsterDefault.eyes
        
        self.currentStressor.monster = monster
        
        self.gotoMonsterName?()
    }
    
}

// MARK: - CompassValidation

extension ChooseMonsterViewController: StressorValidation {
    var error: StressorError {
        return .none
    }
}

// MARK: - CompassFacetEditor

extension ChooseMonsterViewController: StressorFacetEditor {
    func save() {
        //self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentStressor.lastEditedFacet = .monster
        self.currentStressor.hasCustomMonster = false
    }
}
