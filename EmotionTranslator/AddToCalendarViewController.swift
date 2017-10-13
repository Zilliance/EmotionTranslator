//
//  AddToCalendarViewController.swift
//  Balance Pie
//
//  Created by ricardo hernandez  on 3/22/17.
//  Copyright © 2017 Phil Dow. All rights reserved.
//

import UIKit
import SVProgressHUD
import MZFormSheetController
import ZillianceShared

class AddToCalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    fileprivate var zillianceTextViewController: ZillianceTextViewController!
    var preloadedNotification: ZillianceShared.Notification?
    
    var text: String?
    var stressor: Stressor?

    fileprivate var pickerDates: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if let text = self.text {
            self.zillianceTextViewController.textView.text = text
        }
        
        if let stressor = self.stressor {
            self.zillianceTextViewController.stressor = stressor
        }
        
        // date picker

        self.datePicker.layer.cornerRadius = UIConstants.Appearance.cornerRadius
        self.datePicker.layer.borderWidth = UIConstants.Appearance.borderWidth
        self.datePicker.layer.borderColor = UIColor.lightGray.cgColor

        if let preloadedNotification = preloadedNotification {
            self.zillianceTextViewController.textView.text = preloadedNotification.body
            self.datePicker.date = preloadedNotification.startDate ?? Date()
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        guard let body = self.zillianceTextViewController.textView.text, body.characters.count > 0 else {
            
            return
        }
        
        if let error = self.zillianceTextViewController.validation.error {
            switch error {
            case .value:
                self.showAlert(title: "Select Values", message: "Please select one or more values")
            case .placeholder:
                self.showAlert(title: "Enter your action plan", message: "Replace the gray placeholder text with your own plan of action")
            }
            
            return
        }
        
        CalendarHelper.shared.addEvent(with: body, notes: nil, date: self.datePicker.date) { (eventId, error) in
            
            guard eventId != nil else {
                switch error {
                case .notGranted?:
                    self.showAlert(title: "Unable to Access Your Calendar", message: "Please enable access calendar in app settings")
                case .errorSavingEvent?:
                    self.showAlert(title: "Unable to Schedule Event", message: "There was an unexpected error saving your event to calendar")
                default:
                    self.showAlert(title: "Unable to Schedule Event", message: "There was an unexpected error saving your event to calendar")
                }
                
                return
            }
            
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setMaximumDismissTimeInterval(1.0)
            SVProgressHUD.showSuccess(withStatus: "The reminder has been added to your calendar")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController!.popViewController(animated: true)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.zillianceTextViewController = segue.destination as! ZillianceTextViewController
        self.zillianceTextViewController.stressor = self.stressor
    }
    
}

extension AddToCalendarViewController: NotificationEditor {

    func getNotification() -> ZillianceShared.Notification? {
        
        let notification = (self.preloadedNotification?.detached()) ?? Notification()
        
        notification.body = self.zillianceTextViewController.textView.text
        notification.type = .calendar
        notification.startDate = self.datePicker.date
        
        return notification
        
    }
}

