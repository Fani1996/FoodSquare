//
//  MoreViewController.swift
//  FoodSqaure
//
//  Created by Fan on 2016/10/12.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class MoreViewController: VideoSplashViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var videoContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        
        // burger side bar menu
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupVideoBackground()
    }

    
    fileprivate func setupVideoBackground()
    {
        let urlString = Bundle.main.path(forResource: "introduce", ofType: "mp4", inDirectory: "")
        let url = URL(fileURLWithPath: urlString!)
        
        videoFrame = videoContainerView.frame
        fillMode = .resizeAspectFill
        alwaysRepeat = true
        sound = true
        startTime = 12.0
        duration = 70.0
        alpha = 0.7
        backgroundColor = UIColor.black
        
        contentURL = url
        view.isUserInteractionEnabled = false
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
