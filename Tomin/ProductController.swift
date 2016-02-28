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

class ProductViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
}


class ProductTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var categoryId = ""
    var products = [NSManagedObject]()
    
    override func viewDidLoad() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

//        var data = [String: AnyObject]()
//        data["name"] = "Product 1"
//        data["id"] = 1
//        data["categoryId"] = 1
//        model.insert("Product", data: data)
//        
//        data["name"] = "Product 2"
//        data["id"] = 2
//        data["categoryId"] = 1
//        model.insert("Product", data: data)
//        
//        data["name"] = "Product 3"
//        data["id"] = 3
//        data["categoryId"] = 2
//        model.insert("Product", data: data)
//        
//        data["name"] = "Product 4"
//        data["id"] = 4
//        data["categoryId"] = 2
//        model.insert("Product", data: data)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryId == "" {
            products = model.list("Product")
        } else {
            products = model.fetch("Product", column: "categoriaId", value: String(categoryId))
        }
        
        //products = model.fetch("Product", column: "categoriaId", value: String(categoryId))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ProductViewCell = tableView.dequeueReusableCellWithIdentifier("ProductViewCell", forIndexPath: indexPath) as! ProductViewCell
        
        let product = products[indexPath.row]
        
        cell.name.text = product.valueForKey("nombre") as? String
        cell.price.text = ""
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func filterContentForSearchText(searchText: String) {
        
        if searchText == "" {
            if categoryId == "" {
                products = model.list("Product")
            } else {
                products = model.fetch("Product", column: "categoriaId", value: String(categoryId))
            }
            
        } else {
            if categoryId == "" {
                products = model.search("Product", column: "nombre", value: searchText)
            } else {
               products = model.search("Product", column1: "categoriaId", value1: String(categoryId), column2: "nombre", value2: searchText)
            }
        }
        
        tableView.reloadData()
    }

}

extension ProductTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}