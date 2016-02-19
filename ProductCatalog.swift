//
//  ProductCatalog.swift
//  Budgy
//
//  Created by ivan gonzalez on 2/18/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CatalogViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
}


class CatalogTableViewController: UITableViewController {
    
    var products = [NSManagedObject]()
    
    override func viewDidLoad() {
//        model.insertProduct("Product 02")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        products = model.listProducts()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CatalogViewCell = tableView.dequeueReusableCellWithIdentifier("CatalogViewCell", forIndexPath: indexPath) as! CatalogViewCell
        
        let product = products[indexPath.row]
        
        cell.name.text = product.valueForKey("name") as? String
        cell.price.text = "$ 0,000.00"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
        
}