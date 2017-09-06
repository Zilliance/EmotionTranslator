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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //override back button behaviour
        self.navigationController?.navigationBar.addSubview(backcustomButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.backcustomButton.removeFromSuperview()
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
        
        self.backcustomButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        self.backcustomButton.backgroundColor = UIColor.clear
        self.backcustomButton.addTarget(self, action: #selector(self.cancelAction(_:)), for: .touchUpInside)
        
        let item = self.stressorItems[self.currentPageIndex]
        self.setupButton(for: item.scene)
        
    }
    
    private func checkError() -> StressorError {
        guard let vc = self.stressorItems[self.currentPageIndex].viewController as? StressorValidation else {
            return StressorError.none
        }
        return vc.error
    }
    
    private func setupButton(for scene:StressorScene) {
        
        if scene == .monster {
            self.continueButton.setTitle("CREATE YOUR OWN", for: .normal)
        }
        else {
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
        self.setupButton(for: item.scene)
        self.title = self.stressor.title
        self.pageControlViewController.setViewControllers([item.viewController], direction: direction, animated: true, completion: nil)
        
        
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        
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
        
        //just for test
        
        guard self.currentPageIndex < self.stressorItems.count - 1 else {
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
