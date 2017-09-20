//
//  WebViewController.swift
//  Zilliance
//
//  Created by mac on 19-04-17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import Foundation
import UIKit

final class WebViewController: UIViewController, UIWebViewDelegate
{
    var url: URL! // this is to be set before loading the controller and it's not optional
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: self.url))
        
        webView.delegate = self
        
    }
    
    @IBAction func backTapped() {
        self.sideMenuController?.toggle()
    }
    
    private func showTour() {
        guard let tourViewController = UIStoryboard(name: "Tour", bundle: nil).instantiateInitialViewController() as? TourPageViewController else {
            assertionFailure()
            return
        }
        
        tourViewController.presentationType = .fromFaq
        
        let navigationController = UINavigationController(rootViewController: tourViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.contentSize = CGSize(width: webView.frame.size.width, height: webView.scrollView.contentSize.height)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString == "zilliance://emotion-translator/tour" {
            self.showTour()
            return false
        }
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }

    
}
