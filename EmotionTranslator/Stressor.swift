//
//  Stressor.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/27/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift


final class Stressor: Object {
    
    
    @objc enum Facet: Int32 {
        case stressor
        case emotion
        case monster
        case create
        case name
        case introduction
        case conversation
        case takeaway
        
        var pageIndex: Int {
            
            return Int(self.rawValue)
        }
        
    }

    
    dynamic var title: String?
    var completed: Bool = false
    dynamic var dateCreated: Date = Date()
    
    let emotions = List<Emotion>()
    
    dynamic var monster: Monster?
    dynamic var monsterName: String?
    
    dynamic var hasCustomMonster = false
    
    dynamic var answer1: String?
    dynamic var answer2: String?
    dynamic var answer3: String?
    dynamic var answer4: String?
    
    dynamic var lastEditedFacet: Facet = .stressor
    
    dynamic var id: String = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "id"
    }

}
