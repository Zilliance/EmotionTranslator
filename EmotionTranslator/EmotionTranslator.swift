//
//  EmotionTranslator.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class EmotionTranslator: Object {
    
    dynamic var stressor: String?
    var completed: Bool = false
    dynamic var dateCreated: Date = Date()

}

