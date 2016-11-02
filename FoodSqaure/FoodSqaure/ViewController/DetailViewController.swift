//
//  DetailViewController.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/8.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var closeButton: UIButton!

    var restaurant: Restaurant!
    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    private let kTableHeaderCutAway: CGFloat = 80.0
    var headerMaskLayer: CAShapeLayer!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.restaurantImageView.image = UIImage(data: restaurant.image as Data)
        self.closeButton.layer.cornerRadius = closeButton.frame.size.width / 2
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.gray
                
        title = self.restaurant.name
        
        //Setting Up Custom TableView
        setHeaderView()
        setCutAwayView()
        insetTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! DetailTableViewCell
            cell.backgroundColor = UIColor.clear
            // Configure the cell...
            cell.mapButton.isHidden = true
            
            switch indexPath.row {
            case 0:
                cell.fieldLabel.text = "NAME"
                cell.valueLabel.text = restaurant.name
            case 1:
                cell.fieldLabel.text = "TYPE"
                cell.valueLabel.text = restaurant.type
            case 2:
                cell.fieldLabel.text = "LOCATION"
                cell.valueLabel.text = restaurant.location
                cell.mapButton.isHidden = false
            case 3:
                cell.fieldLabel.text = "BEEN HERE"
                cell.valueLabel.text = (restaurant.isVisited.boolValue) ? "Yes, I’ve been here before" : "No"
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
                let destinationController = segue.destination as! ReviewViewController
                destinationController.backgroundImage = self.restaurantImageView.image
            }
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = self.restaurant
        }
    }
    
    
    private func setHeaderView(){
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        
        //Inset TableView
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        //CutAway
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.cgPath
        
        
    }
    
    private func setCutAwayView(){
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        
        headerView.layer.mask = headerMaskLayer
        updateHeaderView()
    }
    
    private func insetTableView(){
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
    }
    

}
