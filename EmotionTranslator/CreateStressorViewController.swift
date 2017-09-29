//
//  CreateStressorViewController.swift
//  EmotionTranslator
//
//  Created by ricardo hernandez  on 8/29/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared

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
    case conversation2
    case takeaway
    case actionplan
}

class CreateStressorViewController: AnalyzedViewController {
    
    fileprivate struct StressorItem {
        let viewController: UIViewController
        let scene: StressorScene
        
        init(for scene: StressorScene, container: CreateStressorViewController) {
            var viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! StressorValidation
            viewController.currentStressor = container.stressor
            viewController.gotoMonsterName = {
                // go to introduction name page
                container.moveToPage(page: Stressor.Facet.name.pageIndex, direction: .forward)
            }
            
            viewController.questionsEnded = {
                container.continueButton.setTitle("CONTINUE", for: .normal)
                container.continueButton.isEnabled = true
            }
            
            self.viewController = viewController as! UIViewController
            self.scene = scene

        }
    }

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var remindMeButton: UIButton!
    
    private let backButton = UIButton()
    
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
            StressorItem(for: .conversation2, container: self),
            StressorItem(for: .takeaway, container: self),
            StressorItem(for: .actionplan, container: self),
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
        
        if (self.stressor.title == nil) {
            Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.newStressor)
        } else {
            Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.stressorResumed)
        }
    }
    
    private func setupView() {
        
        self.title = self.stressor.title ?? ""
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.homeAction(_:)))
        
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
        
        self.backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        self.backButton.setImage(#imageLiteral(resourceName: "chevronBack"), for: .normal)
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0)
        self.backButton.imageView?.contentMode = .scaleAspectFit
        self.backButton.addTarget(self, action: #selector(self.cancelAction(_:)), for: .touchUpInside)
        self.backButton.titleLabel?.font = UIFont.muliRegular(size: 16.0)
        
        let item = self.stressorItems[self.currentPageIndex]
        self.setupButton(for: item)
                
        self.setupNavItem(for: item)

    }
    
    private func checkError() -> StressorError {
        guard let vc = self.stressorItems[self.currentPageIndex].viewController as? StressorValidation else {
            return StressorError.none
        }
        return vc.error
    }
    
    private func setupButton(for item:StressorItem) {
        
        self.continueButton.isEnabled = true
        
        UIView.animate(withDuration: 0.3) { 
            self.backButton.titleLabel?.alpha = 0
            self.remindMeButton.alpha = 0
        }
        
        switch item.scene {
        case .stressor:
            UIView.animate(withDuration: 0.3) {
                self.backButton.titleLabel?.alpha = 1
            }
        case .monster:
            self.continueButton.setTitle("CREATE YOUR OWN", for: .normal)
        case .introduction:
            self.continueButton.setTitle("START", for: .normal)
        case .conversation:
            self.continueButton.setTitle("I'M DONE", for: .normal)
        case .conversation2:
            self.continueButton.setTitle("CONTINUE", for: .normal)
            if let vc = item.viewController as? Conversation2TableViewController {
                self.continueButton.isEnabled = vc.questionsCompleted
            }
        case .actionplan:
            UIView.animate(withDuration: 0.3) {
                self.remindMeButton.alpha = 1
            }
            self.continueButton.setTitle("I'M DONE", for: .normal)
        default:
            self.continueButton.setTitle("CONTINUE", for: .normal)
        }
        
    }

    //MARK: -- User Actions
    
    @IBAction func remindMeAction(_ sender: Any) {
        
        guard let scheduler = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController else {
            assertionFailure()
            return
        }

        scheduler.title = self.stressor.title
        //scheduler.text =
        
        let navigationController = OrientableNavigationController(rootViewController: scheduler)
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
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
        
        self.setupNavItem(for: item)

        Analytics.shared.send(event: ZillianceAnalytics.DetailedEvents.viewControllerShown(item.viewController.analyticsObjectName))

    }
    
    private func setupNavItem(for item: StressorItem) {
        
        if let actionVC = item.viewController as? ActionViewController {

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: actionVC, action: #selector(actionVC.shareTapped))
            
        } else {

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.homeAction(_:)))

        }
        
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
            
            var index = 1
         
            if item.scene == .name && !self.stressor.hasCustomMonster {
                index = 2
            }
           
            self.moveToPage(page: self.currentPageIndex - index , direction: .reverse)
        }
    }
    
     @IBAction func homeAction(_ sender: Any) {
        
        if (self.stressor.title != nil) {
            self.save()
        }
        
        self.navigationController?.popViewController(animated: true)
        
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
            
            //finish stressor
            
            if self.currentPageIndex == Stressor.Facet.actionplan.pageIndex {
                self.stressor.completed = true
                self.save()
                self.navigationController?.popViewController(animated: true)
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.stressorCompleted)

            }
            
            return
        }
        
        //check if conversation is completed
        
        if let currentItem = self.stressorItems[self.currentPageIndex].viewController as? ConversationTableViewController {
            currentItem.reply()
            
            if !currentItem.questionsCompleted {
                return
            }
        }
        
        guard self.checkError() == .none else {
            typealias Scene = Stressor.Facet
            
            // PD:
            // I think we should add a protocol to the pages that allows them to return
            // the error message rather than hard coding on the enumeration here
            
            switch self.checkError() {
            case .selection:
                switch Scene(rawValue: Int32(self.currentPageIndex)) {
                case .emotion?:
                    self.showAlert(title: "Please select an emotion or add your own", message: "")
                default:
                    self.showAlert(title: "Please select one or more items", message: "")
                }
            case .text:
                switch Scene(rawValue: Int32(self.currentPageIndex)) {
                case .stressor?:
                    self.showAlert(title: "Please enter a stressor", message: "")
                case .name?:
                    self.showAlert(title: "Please enter a name for your emotion", message: "")
                case .takeaway?:
                    self.showAlert(title: "Please enter your takeaway and action step below", message: "")
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
