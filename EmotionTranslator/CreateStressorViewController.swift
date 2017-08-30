//
//  CreateStressorViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/29/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

protocol StressorValidation {
    var error: StressorError { get }
    var currentStressor: Stressor! { get set }
}

enum StressorError {
    case text
    case selection
    case none
}

protocol StressorFacetEditor {
    func save()
}

enum StressorScene: String {
    case stressor
    case emotion
}

class CreateStressorViewController: UIViewController {
    
    fileprivate struct StressorItem {
        let viewController: UIViewController
        let scene: StressorScene
        
        init(for scene: StressorScene, container: CreateStressorViewController) {
            var viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! StressorValidation
            viewController.currentStressor = container.stressor
            self.viewController = viewController as! UIViewController
            self.scene = scene

        }
    }

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    
    var stressor: Stressor = Stressor()
    
    var previousScene: StressorScene?
    
    private var currentPageIndex = 0
    
    fileprivate lazy var stressorItems: [StressorItem]  = {
        
        var items: [StressorItem] = [
            StressorItem(for: .stressor, container: self),
            StressorItem(for: .emotion, container: self),
            ]
        
        return items
        
    }()

    
    private lazy var pageControlViewController: UIPageViewController = {
        
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.currentPageIndex = Int(self.stressor.lastEditedFacet.pageIndex)
        controller.setViewControllers([self.stressorItems[self.currentPageIndex].viewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = self.currentPageIndex
        
        let currentItem = self.stressorItems[self.currentPageIndex]
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller

     
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        
        self.pageControl.numberOfPages = 2
        self.pageControl.backgroundColor = .clear
        self.pageControl.pageIndicatorTintColor = .dotColor
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.isUserInteractionEnabled = false
        
        self.addChildViewController(self.pageControlViewController)
        self.pageContainerView.addSubview(self.pageControlViewController.view)
        
        self.pageControlViewController.view.topAnchor.constraint(equalTo: self.pageContainerView.topAnchor).isActive = true
        self.pageControlViewController.view.leadingAnchor.constraint(equalTo: self.pageContainerView.leadingAnchor).isActive = true
        self.pageControlViewController.view.trailingAnchor.constraint(equalTo: self.pageContainerView.trailingAnchor).isActive = true
        self.pageControlViewController.view.bottomAnchor.constraint(equalTo: self.pageContainerView.bottomAnchor).isActive = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    private func checkError() -> StressorError {
        guard let vc = self.stressorItems[self.currentPageIndex].viewController as? StressorValidation else {
            return StressorError.none
        }
        return vc.error
    }

    //MARK: -- User Actions
    
    fileprivate func moveToPage(page: Int, direction: UIPageViewControllerNavigationDirection) {
        
        if let currentItem = self.stressorItems[self.currentPageIndex].viewController as? StressorFacetEditor {
            currentItem.save()
        }
        
        self.currentPageIndex = page
        self.pageControl.currentPage = self.currentPageIndex
        
        let item = self.stressorItems[self.currentPageIndex]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: direction, animated: true, completion: nil)
        
        
    }

    
    @IBAction func continueAction(_ sender: Any) {
        
        guard self.currentPageIndex < self.stressorItems.count - 1 else {
            return
        }
        
        typealias scene = Stressor.Facet
        
        //add error checking
        
        
        self.moveToPage(page: self.currentPageIndex + 1, direction: .forward)
    }
}
