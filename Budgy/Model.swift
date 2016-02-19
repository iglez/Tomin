//
//  Model.swift
//  Budgy
//
//  Created by ivan gonzalez on 2/18/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let model:Model = Model()

class Model {

    func listProducts()-> [NSManagedObject] {
        
        var results = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Product")
        
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return results
    }
    
    func insertProduct(name: String)-> Bool {
        
        var isInserterd = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Product", inManagedObjectContext:managedContext)
        let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        product.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
//            products.append(product)
            isInserterd = true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return isInserterd
    }

    
}
