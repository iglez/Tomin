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
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var contador: UIStepper!
    @IBOutlet weak var importe: UILabel!
    
    @IBAction func quantityChange(sender: UIStepper) {
        cantidad.text = Int(sender.value).description
        render()
    }
 
    func render(){
        if let cantidad = Double(cantidad.text!){
            if let precio = Double(price.text!.stringByReplacingOccurrencesOfString("MXN $", withString: "")){
                
                let largeNumber = cantidad * precio
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                importe.text = "MXN $ \(numberFormatter.stringFromNumber(largeNumber)!)"
            }
        }
    }
 
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
        
        let cartProduct = cartProducts[indexPath.row]
        cell.name.text = cartProduct.valueForKey("nombre") as? String
        cell.price.text = "MXN $\(cartProduct.valueForKey("precio") as! Double)"
        cell.key.text = cartProduct.valueForKey("clave") as? String
        cell.cantidad.text = "\(cartProduct.valueForKey("cantidad") as! Int)"
        cell.contador.value = Double(cartProduct.valueForKey("cantidad") as! Int)
        
        let imageUrl = cartProduct.valueForKey("imagen") as? String
            if imageUrl != "" {
                Util().asyncLoadImage(cell.imagen!, tag: 3, url:imageUrl!)
            }
        
        cell.render()
        
        return cell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
}