//
//  Analytics+EmotionTranslator.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import ZillianceShared

class EmotionTranslatorAnalytics: ZillianceAnalytics {
    
    enum EmotionTranslatorEvent: String, AnalyticEvent {
        
        // emotion translator creation events
        case newStressor
        case stressorCompleted
        case stressorResumed
        
        //monster events
        case ownMonsterCreationStarted 
        case colorChanged
        case shapeChanged
        case eyesChanged
        case mouthChanged
        case hairChanged
        case ownMonsterCreationFinished
        
        //QA events
        case questionAdded
        case questionAnswered
        
        //Profile
        case profileImageSet
        case profileNameSet
        
    }
    
}

