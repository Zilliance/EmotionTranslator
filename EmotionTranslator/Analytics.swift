//
//  Analytics.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Fabric
import Answers
import Amplitude_iOS
import ZillianceShared
import FacebookCore

final class Analytics: AnalyticsService {
    
    static let shared = Analytics()
    
    func initialize() {
        
        //Fabric
        Fabric.with([Answers.self])
        
        //Amplitude
        Amplitude.instance().initializeApiKey("3bde86abbaec15613c028c0bcafe0261")
        
        ZillianceAnalytics.initialize(projectName: "Emotion.Translator.", analyticsService: self)
        
    }
    
    func send(event: AnalyticEvent) {
        
        Answers.logCustomEvent(withName: event.name, customAttributes: event.data)
        
        Amplitude.instance().logEvent(event.name, withEventProperties: event.data)
        
        AppEventsLogger.log(AppEvent(name: event.name))
        
    }
    
}
