//
//  CreateStressorViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/29/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CreateStressorViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.pageControl.numberOfPages = 6
        self.pageControl.backgroundColor = .clear
        self.pageControl.pageIndicatorTintColor = .dotColor
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.isUserInteractionEnabled = false
        
    }

}
