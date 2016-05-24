//
//  CartViewController.swift
//  Tomin
//
//  Created by ivan gonzalez on 5/23/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CartViewController: UIViewController {
    
    var cartTableVC:CartTableViewController!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var contenedor: UIView!
    
    @IBAction func share(sender: AnyObject) {
        print("share...")
        model.deleteAll("CartProduct")
        cartTableVC.reload()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "cartTable"){
            cartTableVC = segue.destinationViewController as! CartTableViewController
        }
    }
}