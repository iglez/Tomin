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
    
    func sync(){
        let endpoint = NSURL(string: "http://localhost:9000/api/1/evt/contact")
        let data = NSData(contentsOfURL: endpoint!)
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
            
//            if let status = json["status"] as? String {
//                print(status)
//            }
            syncProduct(json)
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func syncJson(){
//        let str = "{\"status\":\"ok\"}"
        let str = TestJson().testData()
        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
            
//            if let status = json["status"] as? String {
//                print(status)
//            }
            
            syncProduct(json)
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func syncProduct(json: [String: AnyObject]){
        
        //validate if status is ok
        if let status = json["status"] as? String {
            print(status)
            deleteAll("Product")
            
            if let data = json["data"] as? NSArray {
                data.forEach({ (item) -> () in
                    
                    var product: [String :AnyObject] = [String :AnyObject]()
                    product["id"] = NSUUID().UUIDString
                    
                    if let categoria = item["categoria"] as? String {
                        product["categoria"] = categoria
                        
                        var categorias = [NSManagedObject]()
                        categorias = self.search("Category", column: "nombre", value: categoria)
                        if categorias.isEmpty {
                            var category: [String :AnyObject] = [String :AnyObject]()
                            category["id"] = NSUUID().UUIDString
                            category["nombre"] = categoria
                            self.insert("Category", data: category)
                            
                            product["categoriaId"] = category["id"]
                        } else {
                            if let categoriaId = categorias.first!.valueForKey("id") as? String {
                                product["categoriaId"] = categoriaId
                            }
                        }
                        
                    }
                    
                    if let clave = item["clave"] as? Int {
                        product["clave"] = String(clave)
                    }
                    
                    if let imagen = item["imagen"] as? String {
                        product["imagen"] = imagen
                    }
                    
                    if let nombre = item["nombre"] as? String {
                        product["nombre"] = nombre
                    }
                    
                    if let precio = item["precio"] as? String {
                        product["precio"] = precio
                    }
                    
                    insert("Product", data: product)
                })
                
            }
        }
    }
    
    func deleteAll(table: String) -> Bool{
        var isAllDeleted: Bool = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
                isAllDeleted = true
            }
        } catch let error as NSError {
            print("Detele all data in \(table) error : \(error) \(error.userInfo)")
        }
        return isAllDeleted
    }

    func listProducts(table: String)-> [NSManagedObject] {
        
        var results = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
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
        
        let sectionSortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return results
    }
    
    func search(table:String, column: String, value: String)-> [NSManagedObject] {
        var results = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)

        fetchRequest.predicate = NSPredicate(format:"\(column) contains[c] %@", value)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return results
    }
    

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
