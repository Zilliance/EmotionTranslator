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
    
    dynamic var title: String?
    var completed: Bool = false
    dynamic var dateCreated: Date = Date()
    dynamic var emotion: Emotion?
}
