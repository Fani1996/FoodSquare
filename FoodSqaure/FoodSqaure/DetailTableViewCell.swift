//
//  DetailTableViewCell.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/8.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    @IBOutlet var mapButton:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
