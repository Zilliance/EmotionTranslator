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
        case conversation2
        case takeaway
        case actionplan
        
        var pageIndex: Int {
            
            return Int(self.rawValue)
        }
        
    }
    
    dynamic var title: String?
    dynamic var completed: Bool = false
    dynamic var dateCreated: Date = Date()
    
    let emotions = List<Emotion>()
    
    dynamic var monster: Monster?
    dynamic var hasCustomMonster = false
    
    dynamic var lastEditedFacet: Facet = .stressor
    
    dynamic var id: String = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Freeform conversation
    
    let conversation = List<QuestionAnswer>()
    
    // Four questions conversation (answers only stored)
    
    dynamic var answer1 = ""
    dynamic var answer2 = ""
    dynamic var answer3 = ""
    dynamic var answer4 = ""
    
    dynamic var takeAwayText: String?
    dynamic var takeAwayActions: String?
}

class QuestionAnswer: Object {
    dynamic var question: String?
    dynamic var answer: String?
}
