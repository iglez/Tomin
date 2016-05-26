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
    
    var parent: CartTableViewController!
    var id: String = ""
    
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
                
                var cartData: [String :AnyObject] = [String :AnyObject]()
                cartData["cantidad"] = cantidad
                model.update("CartProduct", column: "id", value: id, data: cartData)
                
                let largeNumber = cantidad * precio
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                importe.text = "MXN $ \(numberFormatter.stringFromNumber(largeNumber)!)"
                
                parent.calcTotal()
            }
        }
    }
 
}

class CartTableViewController: UITableViewController{
    
    var cartProducts = [NSManagedObject]()
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        reload()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CartProductViewCell = tableView.dequeueReusableCellWithIdentifier("CartProductViewCellViewCell", forIndexPath: indexPath) as! CartProductViewCell
        
        let cartProduct = cartProducts[indexPath.row]
        cell.id = cartProduct.valueForKey("id") as! String
        cell.name.text = cartProduct.valueForKey("nombre") as? String
        cell.price.text = "MXN $\(cartProduct.valueForKey("precio") as! Double)"
        cell.key.text = cartProduct.valueForKey("clave") as? String
        cell.cantidad.text = "\(cartProduct.valueForKey("cantidad") as! Int)"
        cell.contador.value = Double(cartProduct.valueForKey("cantidad") as! Int)
        
        let imageUrl = cartProduct.valueForKey("imagen") as? String
            if imageUrl != "" {
                Util().asyncLoadImage(cell.imagen!, tag: 3, url:imageUrl!)
            }
        
        cell.parent = self
        cell.render()
        
        return cell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func reload(){
        cartProducts = model.list("CartProduct", sort: "id")
        self.tableView.reloadData()
    }
    
    func calcTotal(){
        
        var subTotal: Double = 0
        for cartProduct in cartProducts {
            let cantidad = Double(cartProduct.valueForKey("cantidad") as! Int)
            let precio = cartProduct.valueForKey("precio") as! Double
            
            let importe = cantidad * precio
            subTotal = subTotal + importe
//            print("\(cantidad) x \(precio) = \(importe)")
        }
        
        let cartVC:CartViewController = self.parentViewController as! CartViewController
        cartVC.total.text = "Total MXN $\(Util().formatNumber(subTotal))"
    }
    
}