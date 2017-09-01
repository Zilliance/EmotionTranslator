//
//  Analytics.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Firebase
import Fabric
import Answers
import Amplitude_iOS

protocol AnalyticEvent {

    var name: String {get}
    var data: [String: Any]? {get}
    
}

enum ZillianceBasePagedAnalytics: AnalyticEvent {

    case tourPagedViewed(Int)
    
    var name: String {
        switch self {
        case .tourPagedViewed(_):
            return "Tour Paged Viewed"
        }
    }
    
    var data: [String : Any]? {
        
        switch self {
        case .tourPagedViewed(let page):
            return ["Page": page]
        
        }
    }
}


enum ZillianceBaseAnalytics: String, AnalyticEvent {
    
    //Plan?
    case planViewed
    case reminderAdded
    case repeatingReminderAdded
    
    // Sidebar
    case tourVideoStarted
    case tourVideoFinished
    case faqViewed
    case companyViewed
    case privacyPolycyViewed
    case termsViewed
    
    //Summary/sharing
    case emailSent
    case summaryViewed
    case summaryShared

    var name: String {
        return self.rawValue
    }
    
    var data: [String : Any]? {
        return nil
    }
    
}

final class Analytics {
    
    static func initialize() {
        
        //Fabric
        Fabric.with([Answers.self])
        
        //Firebase
        FIRApp.configure()
        
        //Amplitude
        
        Amplitude.instance().initializeApiKey("3bde86abbaec15613c028c0bcafe0261")
        
    }
    
    static func sendEvent(event: AnalyticEvent) {
        
        FIRAnalytics.logEvent(withName: event.name, parameters: event.data)
        
        Answers.logCustomEvent(withName: event.name, customAttributes: event.data)
        
        Amplitude.instance().logEvent(event.name, withEventProperties: event.data)
        
    }
    
}
