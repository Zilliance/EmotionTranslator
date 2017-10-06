//
//  UIImageView+RoundImage.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 9/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRound(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.image = image
    }
}
