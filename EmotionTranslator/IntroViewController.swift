//
//  IntroViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/21/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

fileprivate let tourURL = URL(string: "personalcompass://tour")!
fileprivate let videoURL = URL(string: "personalcompass://video")!

class IntroViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageHeightContraint: NSLayoutConstraint!
    
	var didLayout = false
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.isSmallerThaniPhone6 {
            self.imageHeightContraint.constant = 175
            self.textView.font = UIFont.muliSemiBold(size: 14)
        }
        
        self.linkIntroText()
    }
    
    func linkIntroText() {
        let attrText = self.textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        let tourAttributes: [String: Any] = [
            NSFontAttributeName: UIFont.muliItalic(size: 14),
            NSForegroundColorAttributeName: UIColor.lightBlue,
            NSLinkAttributeName: tourURL
        ]
        let videoAttributes: [String: Any] = [
            NSFontAttributeName: UIFont.muliItalic(size: 14),
            NSForegroundColorAttributeName: UIColor.lightBlue,
            NSLinkAttributeName: videoURL
        ]
        let nameAttributes: [String: Any] = [
            NSFontAttributeName: UIFont.muliItalic(size: 14)
        ]
        
        let tourRange = (attrText.string as NSString).range(of: "Tour")
        let videoRange = (attrText.string as NSString).range(of: "Think.Shift.Release. video")
        let nameRanges = (attrText.string as NSString).ranges(of: "Think.Shift.Release.")
        
        if tourRange.location != NSNotFound {
            attrText.addAttributes(tourAttributes, range: tourRange)
        } else {
            assertionFailure()
        }
        
        if videoRange.location != NSNotFound {
            attrText.addAttributes(videoAttributes, range: videoRange)
        } else {
            assertionFailure()
        }
        
        nameRanges.forEach { range in
            attrText.addAttributes(nameAttributes, range: range)
        }
        
        self.textView.attributedText = attrText
    }
    
    // Fix text view not starting with text at top (!)
    // http://stackoverflow.com/questions/33979214/uitextview-text-starts-from-the-middle-and-not-the-top
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.didLayout == false {
            self.textView.setContentOffset(CGPoint.zero, animated: false)
            self.didLayout = true
        }
    }
   
    // MARK: -

    @IBAction func continueAction(_ sender: UIButton) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let sideMenuViewController = CustomSideViewController()
        sideMenuViewController.setupHome()
        
        sideMenuViewController.view.frame = rootViewController.view.frame
        sideMenuViewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = sideMenuViewController
        }, completion: nil)
    
    }
    
    @IBAction func showTour() {
        guard let onboarding = UIStoryboard(name: "Tour", bundle: nil).instantiateInitialViewController() as? TourPageViewController else {
            assertionFailure()
            return
        }
        
        onboarding.presentationType = .fromFaq // same as from tour
        
        let navigationController = OrientableNavigationController(rootViewController: onboarding)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func showVideo() {
        guard let video  = UIStoryboard(name: "VideoPlayer", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
            assertionFailure()
            return
        }
        
        (video.topViewController as? VideoPlayerViewController)?.presentationMode = .faq
        self.present(video, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension IntroViewController : UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL == tourURL {
            self.showTour()
        } else if URL == videoURL {
            self.showVideo()
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if URL == tourURL {
            self.showTour()
        } else if URL == videoURL {
            self.showVideo()
        }
        
        return false
    }
}

