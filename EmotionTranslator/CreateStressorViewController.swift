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
    var gotoMonsterName: (() -> ())? { get set }
    var questionsEnded: (() -> ())? { get set }
    
}

enum StressorError {
    case text
    case selection
    case monster
    case none
}

protocol StressorFacetEditor {
    func save()
}

enum StressorScene: String {
    case stressor
    case emotion
    case monster
    case create
    case name
    case introduction
    case conversation
}

class CreateStressorViewController: UIViewController {
    
    fileprivate struct StressorItem {
        let viewController: UIViewController
        let scene: StressorScene
        
        init(for scene: StressorScene, container: CreateStressorViewController) {
            var viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! StressorValidation
            viewController.currentStressor = container.stressor
            viewController.gotoMonsterName = {
                // go to monster name page
                container.moveToPage(page: Stressor.Facet.name.pageIndex, direction: .forward)
            }
            
            viewController.questionsEnded = {
                 container.continueButton.setTitle("CONTINUE", for: .normal)
            }
            
            self.viewController = viewController as! UIViewController
            self.scene = scene

        }
    }

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    var backcustomButton: UIButton!
    
    var stressor: Stressor = Stressor()
    
    private var currentPageIndex = 0
    
    fileprivate lazy var stressorItems: [StressorItem]  = {
        
        var items: [StressorItem] = [
            StressorItem(for: .stressor, container: self),
            StressorItem(for: .emotion, container: self),
            StressorItem(for: .monster, container: self),
            StressorItem(for: .create, container: self),
            StressorItem(for: .name, container: self),
            StressorItem(for: .introduction, container: self),
            StressorItem(for: .conversation, container: self),
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
        
        self.title = self.stressor.title ?? ""
        
        self.pageControl.numberOfPages = self.stressorItems.count
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
        
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.cancelAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let item = self.stressorItems[self.currentPageIndex]
        self.setupButton(for: item)
        
    }
    
    private func checkError() -> StressorError {
        guard let vc = self.stressorItems[self.currentPageIndex].viewController as? StressorValidation else {
            return StressorError.none
        }
        return vc.error
    }
    
    private func setupButton(for item:StressorItem) {
        
        switch item.scene {
        case .monster:
            self.continueButton.setTitle("CREATE YOUR OWN", for: .normal)
        case .introduction:
            self.continueButton.setTitle("START", for: .normal)
        case .conversation:
            if let vc = item.viewController as? ConversationTableViewController {
                let text = vc.questionsCompleted ? "CONTINUE" : "REPLY"
                self.continueButton.setTitle(text, for: .normal)
            }
        default:
            self.continueButton.setTitle("CONTINUE", for: .normal)
        }
        
    }

    //MARK: -- User Actions
    
    fileprivate func moveToPage(page: Int, direction: UIPageViewControllerNavigationDirection) {
        
        if let currentItem = self.stressorItems[self.currentPageIndex].viewController as? StressorFacetEditor {
            currentItem.save()
        }
        
        self.currentPageIndex = page
        self.pageControl.currentPage = self.currentPageIndex
        
        let item = self.stressorItems[self.currentPageIndex]
        self.setupButton(for: item)
        self.title = self.stressor.title
        self.pageControlViewController.setViewControllers([item.viewController], direction: direction, animated: true, completion: nil)
        
        Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorPageEvent.stressorPageViewed(page))
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        
        let item = self.stressorItems[self.currentPageIndex]
        
        if item.scene == .stressor {
            
            if (self.stressor.title != nil) {
                self.save()
            }
            
            self.navigationController?.popViewController(animated: true)
        }
            
        else {
            
            let index = self.stressor.hasCustomMonster == false && item.scene == .name ? 2 : 1
            
            self.moveToPage(page: self.currentPageIndex - index , direction: .reverse)
        }
    }
    
    private func save() {
        
        if let currentItem = self.stressorItems[self.currentPageIndex].viewController as? StressorFacetEditor {
            currentItem.save()
        }
        
        let update = Database.shared.user.stressors.filter { $0.id == self.stressor.id }.count > 0
        
        if (update) {
            Database.shared.add(realmObject: self.stressor, update: true)
        }
        else {
            Database.shared.save {
                Database.shared.user.stressors.append(self.stressor)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        
        guard self.currentPageIndex < self.stressorItems.count - 1 else {
            
            if let currentItem = self.stressorItems[self.currentPageIndex].viewController as? ConversationTableViewController {
                currentItem.reply()
                
                return
            }
            
            return
        }
        
        guard self.checkError() == .none else {
            typealias scene = Stressor.Facet
            
            switch self.checkError() {
            case .selection:
                switch self.currentPageIndex {
                case scene.emotion.pageIndex:
                    self.showAlert(title: "Please select one or more items", message: "")
                default:
                    self.showAlert(title: "Please select one or more items", message: "")
                }
            case .text:
                switch self.currentPageIndex {
                case scene.stressor.pageIndex:
                    self.showAlert(title: "Please enter a stressor", message: "")
                default:
                    self.showAlert(title: "Please enter text", message: "")
                }
                
            default:
                //no error
                break
            }

            return
        }
        
        self.moveToPage(page: self.currentPageIndex + 1, direction: .forward)
    }
}
