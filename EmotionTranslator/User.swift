//
//  User.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/27/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    let emotionTranslators = List<EmotionTranslator>()
    
    var incompleteStressors: [EmotionTranslator] {
        return Array( self.emotionTranslators.filter("completed = false") )
    }
}
