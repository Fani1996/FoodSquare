//
//  ReviewViewController.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/8.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var dialogView:UIView!
    var backgroundImage: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundImageView.image = backgroundImage
        //Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        dialogView.transform = scale.concatenating(translate)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        let scale = CGAffineTransform(scaleX: 1, y: 1)
                        let translate = CGAffineTransform(translationX: 0, y: 0)
                        self.dialogView.transform = scale.concatenating(translate)
            }, completion: nil)
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
