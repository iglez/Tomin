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

    func listProducts(table: String)-> [NSManagedObject] {
        
        var results = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return results
    }
    
    func fetch(table:String, column: String, value: String)-> [NSManagedObject] {
        var results = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.predicate = NSPredicate(format:"\(column) == %@", value)
        
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return results
    }
    
//    func insertProduct(name: String, categoryId: Int)-> Bool {
    func insert(table: String, data: [String: AnyObject])-> Bool {
        
        var isInserterd = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(table, inManagedObjectContext:managedContext)
        let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
//        var mimap = [String: AnyObject]()
//        mimap["name"] = name
//        mimap["categoryId"] = categoryId
        product.setValuesForKeysWithDictionary(data)
        
        
//        product.setValue("dasdasdasd", forKey: "name")
//        product.setValue(categoryId, forKey: "categoryId")
        
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
