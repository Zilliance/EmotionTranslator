//
//  Analytics+EmotionTranslator.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

class EmotionTranslatorAnalytics: ZillianceAnalytics {
    
    enum EmotionTranslatorPageEvent: AnalyticEvent {
        
        case stressorPageViewed(Int)
        
        var name: String {
            switch self {
            case .stressorPageViewed(_):
                return "Paged Viewed"
            }
        }
        
        var data: [String : Any]? {
            
            switch self {
            case .stressorPageViewed(let page):
                return ["Page": page]
                
            }
        }
    }
    
    enum EmotionTranslatorEvent: String, AnalyticEvent {
        
        //sign up
        case signUp
        
        // emotion translator creation events
        case newStressor
        case stressorCompleted
        
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
        
    }
    
}

