//
//  Monster.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class Monster: Object {
    
    /// Color is a named asset, e.g. "red, yellow" but represented internally as an int
    /// none represents no selection and uses an empty image asset
    
    @objc enum Color: Int {
        case none
        case blue
        case green
        case yellow
        case purple
        case red
        
        static var all: [Color] {
            return [.blue, .green, .yellow, .purple, .red]
        }
        
        var image: UIImage {
            if self == .none {
                return UIImage(named: "color-none")!
            } else {
                return UIImage(named: "color-\(self.stringValue)")!
            }
        }
        
        var color: UIColor {
            switch self {
            case .none:     return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            case .red:      return UIColor(red: 234.0/255.0, green: 91.0/255.0, blue: 67.0/255.0, alpha: 1)
            case .yellow:   return UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 55.0/255.0, alpha: 1)
            case .green:    return UIColor(red: 84.0/255.0, green: 186/255.0, blue: 42.0/255.0, alpha: 1)
            case .blue:     return UIColor(red: 0.0/255.0, green: 184.0/255.0, blue: 231.0/255.0, alpha: 1)
            case .purple:   return UIColor(red: 85.0/255.0, green: 95.0/255.0, blue: 193.0/255.0, alpha: 1)
            }
        }
        
        var stringValue: String {
            switch self {
            case .none:     return "none"
            case .red:      return "red"
            case .yellow:   return "yellow"
            case .green:    return "green"
            case .blue:     return "blue"
            case .purple:   return "purple"
            }
        }
    }
    
    /// Shape is a named asset, e.g. "heart, oval" but represented internally as an int
    /// none represents no selection and uses an empty image asset
    /// Shape assets are colored
    
    @objc enum Shape: Int {
        case none
        case heart
        case oval
        case pointed
        case square
        case triangle
        
        static var all: [Shape] {
            return [.heart, .oval, .pointed, .square, .triangle]
        }
        
        func image(with color: Color) -> UIImage {
            if self == .none {
                return UIImage(named: "shape-none")!
            } else {
                return UIImage(named: "shape-\(color.stringValue)-\(self.stringValue)")!
            }
        }
        
        var stringValue: String {
            switch self {
            case .none:     return "none"
            case .heart:    return "heart"
            case .oval:     return "oval"
            case .pointed:  return "pointed"
            case .square:   return "square"
            case .triangle: return "triangle"
            }
        }
    }
    
    /// Hair is a simple numeric asset
    /// none represents no selection and uses an empty image asset
    /// Hair assets are colored
    
    @objc enum Hair: Int {
        case none
        case one
        case two
        case three
        case four
        case five
        
        static var all: [Hair] {
            return [.one, .two, .three, .four, .five]
        }
        
        func image(with color: Color) -> UIImage {
            if self == .none {
                return UIImage(named: "hair-none")!
            } else {
                // return UIImage(named: "hair-\(color.stringValue)-\(self.rawValue)")!
                return UIImage(named: "hair-\(self.rawValue)")!
            }
        }
    }
    
    /// Mouth is a simple numeric asset
    /// none represents no selection and uses an empty image asset
    /// Mouth assets have no color
    
    @objc enum Mouth: Int {
        case none
        case one
        case two
        case three
        case four
        case five
        
        static var all: [Mouth] {
            return [.one, .two, .three, .four, .five]
        }
        
        var image: UIImage {
            if self == .none {
                return UIImage(named: "mouth-none")!
            } else {
                return UIImage(named: "mouth-\(self.rawValue)")!
            }
        }
    }
    
    /// Eyes is a simple numeric asset
    /// none represents no selection and uses an empty image asset
    /// Eyes assets have no color
    
    @objc enum Eyes: Int {
        case none
        case one
        case two
        case three
        case four
        case five
        
        static var all: [Eyes] {
            return [.one, .two, .three, .four, .five]
        }
        
        var image: UIImage {
            if self == .none {
                return UIImage(named: "eyes-none")!
            } else {
                return UIImage(named: "eyes-\(self.rawValue)")!
            }
        }
    }
    
    struct Default {
        let color: Color
        let shape: Shape
        let hair: Hair
        let mouth: Mouth
        let eyes: Eyes
    }
    
    dynamic var color: Color = .none
    dynamic var shape: Shape = .none
    dynamic var hair: Hair = .none
    dynamic var mouth: Mouth = .none
    dynamic var eyes: Eyes = .none
    
}
