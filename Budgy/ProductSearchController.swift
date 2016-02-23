//
//  SearchController.swift
//  Budgy
//
//  Created by ivan gonzalez on 2/22/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProductSearchViewCell : UITableViewCell{
    @IBOutlet weak var name: UILabel!


}

class ProductSearchViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var products = [NSManagedObject]()

    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String) {
        products = model.search("Product", column: "name", value: searchText)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductSearchViewCell = tableView.dequeueReusableCellWithIdentifier("ProductSearchViewCell", forIndexPath: indexPath) as! ProductSearchViewCell
        
        let product = products[indexPath.row]
        
        cell.name.text = product.valueForKey("name") as? String
//        cell.price.text = ""

        return cell
    }
    
}

extension ProductSearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
