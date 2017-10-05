//
//  ProfileViewController.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 19-09-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

final class ProfileViewController: AutoscrollableViewController {
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var avatarImage: UIImageView!
    
    var presentedFromIntro = true
    
    private var hadNameSet = false
    private var hadImageSet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.setTitle(self.presentedFromIntro ? "Continue" : "Save Changes", for: .normal)
        skipButton.isHidden = !self.presentedFromIntro

        //text inset for textfield
        nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(50, 0, 0);
        nameTextField.font = UIFont.muliRegular(size: 14)
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.color(forRed: 235, green: 235, blue: 235, alpha: 1).cgColor
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        
        if !self.presentedFromIntro {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(showLeftMenu))
        }
        
        loadUserData()
    }
    
    @objc private func showLeftMenu() {
        self.sideMenuController?.toggle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (!self.presentedFromIntro) {
            self.saveData()
        }
    }
    
    func loadUserData() {
        let filename = FileUtils.profileImagePath

        if let data = try? Data(contentsOf: filename) {
            let image = UIImage(data: data)
            self.avatarImage.image = image
            self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0
            self.hadImageSet = true
        }
        
        if let userName = Database.shared.user.name {
            self.nameTextField.text = userName
            self.hadNameSet = true
        }
        
    }
    
    @IBAction func avatarIconTapped() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) {[unowned self] action in
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(takePhoto)
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { action in
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(choosePhoto)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    
    }
    
    func showHomeScreen() {
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
    
    fileprivate func saveData() {
        let user = Database.shared.user
        if let name = nameTextField.text?.trimmed {
            Database.shared.save {
                user?.name = name
            }
            
            if (!self.hadNameSet) {
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.profileNameSet)
            }
        }
        
        if let image = avatarImage.image, let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = FileUtils.profileImagePath
            try? data.write(to: filename)
            
            if (!self.hadImageSet) {
                Analytics.shared.send(event: EmotionTranslatorAnalytics.EmotionTranslatorEvent.profileImageSet)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.saveData()
        if self.presentedFromIntro {
            self.showHomeScreen()
        }
    }
    
    @IBAction func skipAction() {
        showHomeScreen()
    }
    
    override var editingViewFrame: CGRect? {
        return self.nameTextField.frame
    }

    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.avatarImage.image = image
            self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2.0
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
