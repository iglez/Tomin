//
//  CategoryController.swift
//  Budgy
//
//  Created by ivan gonzalez on 2/22/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    
}

class CategoryTableViewController: UITableViewController{
    
    var categories = [NSManagedObject]()
    
    override func viewDidLoad() {
//        var data = [String: AnyObject]()
//        data["name"] = "Category 1"
//        data["id"] = 1
//        model.insert("Category", data: data)
//        data["name"] = "Category 2"
//        data["id"] = 2
//        model.insert("Category", data: data)
    }
    
    override func viewWillAppear(animated: Bool) {
        categories = model.listProducts("Category")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CategoryViewCell = tableView.dequeueReusableCellWithIdentifier("CategoryViewCell", forIndexPath: indexPath) as! CategoryViewCell
        
        let category = categories[indexPath.row]
        
        cell.categoryName.text = category.valueForKey("name") as? String
        
        return cell

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "CatToProd"){
            let viewController:ProductTableViewController = segue.destinationViewController as! ProductTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let category = categories[indexPath!.row]
            viewController.categoryId = category.valueForKey("id") as! Int
        }
        
    }
}