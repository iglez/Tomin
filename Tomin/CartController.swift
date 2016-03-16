//
//  CartController.swift
//  Tomin
//
//  Created by ivan gonzalez on 3/15/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CartProductViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
   
 
}

class CartTableViewController: UITableViewController{
    
    var cartProducts = [NSManagedObject]()
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        cartProducts = model.list("CartProduct", sort: "id")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CartProductViewCell = tableView.dequeueReusableCellWithIdentifier("CartProductViewCellViewCell", forIndexPath: indexPath) as! CartProductViewCell
        
        //let cartProduct = cartProducts[indexPath.row]
        
        //cell.name.text = cartProduct.valueForKey("id") as? String
        cell.name.text = "The name"
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
}