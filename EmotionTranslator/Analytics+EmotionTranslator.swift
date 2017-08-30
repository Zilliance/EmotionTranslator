//
//  Analytics+EmotionTranslator.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

enum EmotionTranslatorEvent: String, AnalyticEvent {
    
    case newStressor
    case stressorCompleted
    
    var name: String {
        
        switch self {
        case .newStressor:
            return "New Stressor"
        case .stressorCompleted:
            return "Stressor Completed"
        }
    }
    
    var data: [String : Any]? {
        
        switch self {
        default:
            return nil
        }
        
    }
    
}
