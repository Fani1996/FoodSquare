//
//  RestaurantTableViewController.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/7.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ParallaxHeaderViewDelegate {

    var restaurants:[Restaurant] = []
    var fetchResultController:NSFetchedResultsController<Restaurant>!
    let hasViewedWalkthrough = UserDefaults.standard.bool(forKey: "hasViewedWalkthrough")
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Determing IntroView whether to show
        if hasViewedWalkthrough == false {
            if let pageViewController =
                storyboard?.instantiateViewController(withIdentifier: "PageViewController") as?
                PageViewController {
                self.present(pageViewController, animated: true, completion: nil)
            }
        }
        
        fetchRestaurant()
        
        // Empty back button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // burger side bar menu
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Setting NavigationBar
        self.navigationController?.navigationBar.setMyBackgroundColor(color: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0))
        
        let imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: self.tableView.bounds.width,height: 150))
        imageView.image = UIImage(named: "intro3")
        imageView.contentMode = .scaleAspectFill
        
        let heardView = ParallaxHeaderView(style: .Thumb,subView: imageView, headerViewSize: CGSize(width:self.tableView.frame.width,height: 64), maxOffsetY: 120, delegate: self as ParallaxHeaderViewDelegate)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.tableHeaderView = heardView
        
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let heardView = self.tableView.tableHeaderView as! ParallaxHeaderView
        heardView.layoutHeaderViewWhenScroll(offset: scrollView.contentOffset)
        
    }
    
    
    
    
    // MARK: - Core Data Related
    
    //CoreData Fetch func
    
    func fetchRestaurant() {
        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        
        let context = getContext()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<Restaurant>, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            var r = try fetchResultController.performFetch()
            restaurants = fetchResultController.fetchedObjects! as [Restaurant]
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for result in (searchResults as! [NSManagedObject]) {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(result.value(forKey: "name")!)")
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func deleteCoreData(indexPath: IndexPath){
        //设置查询条件
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //查询操作
        let restaurantToDelete = self.fetchResultController.object(at: indexPath) as Restaurant
        context.delete(restaurantToDelete)
        
    }
    
    func removeAllCoreData(){
        guard let psc = getContext().persistentStoreCoordinator else { return }
        guard let store = psc.persistentStores.last as NSPersistentStore? else { return }
        let storeUrl = psc.url(for: store)
        
        getContext().performAndWait() {
            self.getContext().reset()
            do{
                try psc.remove(store)
                try FileManager.default.removeItem(at: storeUrl)
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
                print("remove coredata file success!")
                
            }catch{
                print("remove coredata file error")
            }
        }//managedContext.performBlockAndWait()
    }
    
    

    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
            indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.thumbnailImageView.image = UIImage(data: restaurant.image as Data)
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        //mainView Configuration
        cell.mainView.layer.shadowColor = UIColor(red: 147.0/255.0, green: 112.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        cell.mainView.layer.shadowOpacity = 0.3
        cell.mainView.layer.shadowOffset = CGSize(width: 1, height: 3)
        cell.thumbnailImageView.layer.cornerRadius = 3
        
        return cell
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: {
            (action:UITableViewRowAction, indexPath:IndexPath!) -> Void in
                let shareMenu = UIAlertController(title: nil, message: "Share using",
                                                  preferredStyle: .actionSheet)
                let twitterAction = UIAlertAction(title: "Twitter", style:
                    UIAlertActionStyle.default, handler: nil)
                let facebookAction = UIAlertAction(title: "Facebook", style:
                    UIAlertActionStyle.default, handler: nil)
                let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.default,
                                                handler: nil)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,
                                                 handler: nil)
                shareMenu.addAction(twitterAction)
                shareMenu.addAction(facebookAction)
                shareMenu.addAction(emailAction)
                shareMenu.addAction(cancelAction)
                self.present(shareMenu, animated: true, completion: nil)
        } )
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: {
            (action:UITableViewRowAction, indexPath:IndexPath!) -> Void in
            // Delete the row from the data source
            self.deleteCoreData(indexPath: indexPath)
        })
        
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func unwindToHomeScreen(_ segue:UIStoryboardSegue) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            } }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    

}

