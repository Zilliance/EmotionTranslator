//
//  VideoPlayerViewController.swift
//  Zilliance
//
//  Created by ricardo hernandez  on 5/1/17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerViewController: UIViewController {
    enum PresentationMode {
        case sidebar
        case faq
    }
    
    var presentationMode = PresentationMode.sidebar {
        didSet {
            self.updatePresentation()
        }
    }

    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Video"
        self.updatePresentation()
        // self.youtubePlayer.loadVideoID("CB0UlN6gt6k")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.youtubePlayer.stop()

    }
    
    func updatePresentation() {
        switch self.presentationMode {
        case .sidebar:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-icon"), style: .plain, target: self, action: #selector(backTapped(_:)))
        case .faq:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func backTapped(_ sender: Any) {
        self.sideMenuController?.toggle()
    }
    
    @IBAction func close(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }

}
