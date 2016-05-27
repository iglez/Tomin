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
//        print("share...")

        var textBody = "\(total.text!) </br></br>"
        
        let cartProducts = cartTableVC.cartProducts
        var subTotal: Double = 0
        for cartProduct in cartProducts {
            let cantidad = Double(cartProduct.valueForKey("cantidad") as! Int)
            let precio = cartProduct.valueForKey("precio") as! Double
            
            let nombre = cartProduct.valueForKey("nombre") as! String
            let clave = cartProduct.valueForKey("clave") as! String
            
            let importe = cantidad * precio
            subTotal = subTotal + importe
            
            textBody = textBody + "\n" + "\(Int(cantidad)) \(nombre) (\(clave)) \(Int(cantidad)) x \(Util().formatNumber(precio)) = $\(Util().formatNumber(importe)) </br>"
            
//            print("\(textBody)")

        }
        
//        print(textBody)
        
        let shareItems:Array = [textBody]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        
        model.deleteAll("CartProduct")
        cartTableVC.reload()
        total.text = "Total MXN $0"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "cartTable"){
            cartTableVC = segue.destinationViewController as! CartTableViewController
        }
    }
}