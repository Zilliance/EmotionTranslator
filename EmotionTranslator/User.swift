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
    
    let stressors = List<Stressor>()
    
    var incompleteStressors: [Stressor] {
        return Array( self.stressors.filter("completed = false") )
    }
    
    dynamic var name: String?

}
