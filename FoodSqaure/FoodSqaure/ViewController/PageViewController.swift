//
//  PageViewController.swift
//  FoodSqaure
//
//  Created by Fan on 2016/10/10.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageImages = ["intro1", "intro2", "intro3"]
    var pageSubHeadings = ["Pin your favourite restaurants and create your own food guide", "Search and locate your favourite restaurant on Maps", "Find restaurants pinned by your friends and other foodies around the world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the data source to itself
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = self.viewControllerAtIndex(index: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true,
                               completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        if let pageContentViewController =
            storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as?
            PageContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    func forward(index: Int) {
        
        if let nextViewController = self.viewControllerAtIndex(index: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
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
