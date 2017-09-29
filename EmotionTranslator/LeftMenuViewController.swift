//
//  LeftMenuViewController.swift
//  Zilliance
//
//  Created by Ignacio Zunino on 17-04-17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import Foundation
import UIKit
import SideMenuController
import ZillianceShared

final class LeftMenuViewController: UIViewController {
    enum Row: Int {
        case profile = 0
        case spacer1
        case howItWorks
        case tour
        // case videos // copy cell, change title to video, uncomment here and below
        case faq
        case spacer2
        case about
        case company
    }
    
    @IBOutlet var logoViewWidthConstraint: NSLayoutConstraint!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .darkBlue
        
        if UIDevice.isSmallerThaniPhone6 {
            self.logoViewWidthConstraint.constant = 60
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITableViewController {
            self.tableView = vc.tableView
            self.tableView.backgroundColor = .darkBlue
            self.tableView.tableFooterView = UIView()
            self.tableView.delegate = self
        }
    }
    
    func showHTMLView(htmlFile: String, title: String) {
        let htmlFilePath = Bundle.main.path(forResource: htmlFile, ofType: "html")
        let url = URL(fileURLWithPath: htmlFilePath!)
        
        if let webController = UIStoryboard(name: "WebView", bundle: nil).instantiateInitialViewController() as? WebViewController {
            webController.title = title
            webController.url = url
            
            let navigationController = UINavigationController(rootViewController: webController)
            
            self.sideMenuController?.embed(centerViewController: navigationController)
        }
    }
    
    var showingHome: Bool {
        guard let currentNavigation = self.sideMenuController?.centerViewController as? UINavigationController, currentNavigation.viewControllers.first is HomeViewController else {
            return false
        }
        
        return true
    }
    
    func showCompassView() {
        guard let sideMenu = self.sideMenuController else {
            assertionFailure()
            return
        }
        
        guard !self.showingHome else {
            self.sideMenuController?.toggle()
            return
        }
        
        let home = UIStoryboard(name: "HomeViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        sideMenu.embed(centerViewController: home, cacheIdentifier: "HomeViewController")
    }
    
    @IBAction func pieButtonTapped() {
        self.showCompassView()
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        self.showHTMLView(htmlFile: "zilliance privacy policy", title: "Privacy Policy")
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.privacyPolycyViewed)
    }
    
    @IBAction func termsOfServicesTapped(_ sender: Any) {
        self.showHTMLView(htmlFile: "zilliance terms of service", title: "Terms Of Service")
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.termsOfServicesViewed)
    }
    
    func showAboutCompany() {
        let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "AboutCompany")
        let nav = UINavigationController(rootViewController: vc)
        self.sideMenuController?.embed(centerViewController: nav)
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.companyViewed)
    }
    
    func showTour() {
        guard  let vc = UIStoryboard(name: "Tour", bundle: nil).instantiateInitialViewController() as? TourPageViewController else {
            assertionFailure()
            return
        }
        vc.presentationType = .fromMenu
        let nav = UINavigationController(rootViewController: vc)
        self.sideMenuController?.embed(centerViewController: nav)
    }
    
    func showProfile() {
        guard  let vc = UIStoryboard(name: "Intro", bundle: nil).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else {
            assertionFailure()
            return
        }
        vc.presentedFromIntro = false
        let nav = UINavigationController(rootViewController: vc)
        self.sideMenuController?.embed(centerViewController: nav)
    }
    
    func showVideo() {
        guard let vc  = UIStoryboard(name: "VideoPlayer", bundle: nil).instantiateInitialViewController() else {
            assertionFailure()
            return
        }
        self.sideMenuController?.embed(centerViewController: vc)
    }
    
    func showFaq() {
        self.showHTMLView(htmlFile: "faq", title: "FAQ")
        Analytics.shared.send(event: ZillianceAnalytics.BaseEvents.faqViewed)
    }
}

// MARK: - Table View Delegate

extension LeftMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Row(rawValue: indexPath.row) {
        case .howItWorks?: fallthrough
        case .about?:
            return 30
        case .spacer1?: fallthrough
        case .spacer2?:
            return 20
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Row(rawValue: indexPath.row) {
        case .howItWorks?: fallthrough
        case .about?: fallthrough
        case .spacer1?: fallthrough
        case .spacer2?:
            cell.selectionStyle = .none
            cell.hideSeparatorInsets()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Row(rawValue: indexPath.row) {
        case .profile?:
            self.showProfile()
        case .tour?:
            self.showTour()
//        case .videos?:
//            self.showVideo()
        case .faq?:
            self.showFaq()
        case .company?:
            self.showAboutCompany()
        default:
            break
        }
    }
}
