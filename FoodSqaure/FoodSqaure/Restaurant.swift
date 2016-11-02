//
//  Restaurant.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/8.
//  Copyright © 2016年 Fan. All rights reserved.
//

import Foundation
import CoreData

@objc(Restaurant)
class Restaurant:NSManagedObject {
    @NSManaged var name:String!
    @NSManaged var type:String!
    @NSManaged var location:String!
    @NSManaged var image:NSData!
    @NSManaged var isVisited:NSNumber!
}
