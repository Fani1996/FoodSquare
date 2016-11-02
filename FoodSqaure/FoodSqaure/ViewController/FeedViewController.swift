//
//  FeedViewController.swift
//  FoodSqaure
//
//  Created by Fan on 2016/11/2.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    
    var nameList = ["B&Q","Apple","Roast King","Starry Eye","T-Bone","Crazy Chicken"]
    var imageList = ["intro1","intro2","intro3","banner1","banner2","banner3"]
    var locationList = ["Wuhan","Hongkong","Guangzhou","Shanghai","Beijing","Texas"]
    var typeList = ["Snack","Lunch","Dinner","Fast Food","Drink","Snack"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // burger side bar menu
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }

    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath as IndexPath) as! FeedTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = nameList[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: imageList[indexPath.row])
        cell.locationLabel.text = locationList[indexPath.row]
        cell.typeLabel.text = typeList[indexPath.row]
        
        // Circular image
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
        }
        
    }
    
    
    
}
