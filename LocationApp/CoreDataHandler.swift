/*
 * CoreDataHandler.swift
 * Assign 1
 *
 * Copyright 2018 Justin Greene,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Purpose: Handles creation (if necessary) and manipulation of the core data database as per assignment 8 SER423 2018 Spring B
 *
 * @author Justin Greene  mailto:jagree19@asu.edu
 * @version April 2018
 */

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func locationExists(withName:String) -> Bool {
        var ret:Bool = false
        let selectRequest:NSFetchRequest<PlaceDescription> = PlaceDescription.fetchRequest()
        selectRequest.predicate = NSPredicate(format: "name == %@", withName)
        let context = getContext()
        do {
            let results = try context.fetch(selectRequest)
            if results.count > 0 {
                ret = true
            }
        } catch let error as NSError {
            NSLog("error selecting student \(withName) \(error)")
        }
        return ret
    }
    
    class func saveLocation(name:String, descrip:String, category:String, address_title:String, address_street:String, elevation:Double, latitude:Double, longitude:Double) -> Bool {
        
        var ret:Bool =  false
        
        if !CoreDataHandler.locationExists(withName: name) {
            let context = getContext()
            let entity = NSEntityDescription.entity(forEntityName: "PlaceDescription", in: context)
            let managedObject = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObject.setValue(name, forKey: "name")
            managedObject.setValue(descrip, forKey: "descrip")
            managedObject.setValue(category, forKey: "category")
            managedObject.setValue(address_title, forKey: "address_title")
            managedObject.setValue(address_street, forKey: "address_street")
            managedObject.setValue(elevation, forKey: "elevation")
            managedObject.setValue(latitude, forKey: "latitude")
            managedObject.setValue(longitude, forKey: "longitude")
            
            do {
                try context.save()
                ret = true
            } catch {
                print("error saving object")
                ret = false
            }
        }
        return ret
    }
    
    class func fetchLocations() -> [PlaceDescription]? {
        let context = getContext()
        var location:[PlaceDescription]? = nil
        do {
            location = try context.fetch(PlaceDescription.fetchRequest())
            return location
        } catch {
            return location
        }
    }
    
    class func fetchLocationNames() -> [String]? {
        let locations = CoreDataHandler.fetchLocations()
        var locNames:[String] = [String]()
        for aLoc in locations! {
            locNames.append((aLoc as AnyObject).value(forKey:"name") as! String)
        }
        return locNames
    }
    /*
     class func fetchLocation(_ name:String) -> (name:String, descrip:String, category:String, address_titles:String,
     address_street:String, elevation:Double, latitude:Double, longitude:Double) {
     
     let fetchALoc:NSFetchRequest<PlaceDescription> = PlaceDescription.fetchRequest()
     fetchALoc.predicate = NSPredicate(format: "name=%@", name)
     let context = getContext()
     var ret:(name:String, descrip:String, category:String, address_titles:String,
     address_street:String, elevation:Double, latitude:Double, longitude:Double) = ("name","","","","",0.0,0.0,0.0)
     do {
     let results = try context.fetch(fetchALoc)
     if results.count > 0 {
     let name = (results[0] as AnyObject).value(forKey: "name") as? String
     let descrip = (results[0] as AnyObject).value(forKey: "descrip") as? String
     let category = (results[0] as AnyObject).value(forKey: "category") as? String
     let address_title = (results[0] as AnyObject).value(forKey: "address_title") as? String
     let address_street = (results[0] as AnyObject).value(forKey: "address_street") as? String
     let elevation = (results[0] as AnyObject).value(forKey: "elevation") as? Double
     let latitude = (results[0] as AnyObject).value(forKey: "latitude") as? Double
     let longitude = (results[0] as AnyObject).value(forKey: "longitude") as? Double
     ret = (name!, descrip!, category!, address_title!, address_street!, elevation!, latitude!, longitude!)
     
     }
     } catch {
     print("error getting a location: \(name)")
     }
     return ret
     }
     */
    
    class func fetchLocation(_ name:String) -> PlaceDescription {
        
        let fetchALoc:NSFetchRequest<PlaceDescription> = PlaceDescription.fetchRequest()
        fetchALoc.predicate = NSPredicate(format: "name == %@", name)
        let context = getContext()
        var results:[PlaceDescription] = [PlaceDescription]()
        do {
            results = try context.fetch(fetchALoc)
            if results.count > 0 {
                return results[0]
            }
        } catch let error as NSError {
            print("error fetching location \(name) error: \(error)")
        }
        return results[0]
    }
    
    class func deleteLocation(name:String) -> Bool {
        var ret:Bool = false
        let selectRequest:NSFetchRequest<PlaceDescription> = PlaceDescription.fetchRequest()
        selectRequest.predicate = NSPredicate(format: "name == %@", name)
        let context = getContext()
        do {
            let results = try context.fetch(selectRequest)
            if results.count > 0 {
                context.delete(results[0] as NSManagedObject)
                ret = true
            }
        } catch let error as NSError {
            NSLog("error deleting location \(name). Error \(error)")
        }
        
        return ret
    }
    
    class func updateLocation(name:String, descrip:String, category:String, address_title:String, address_street:String, elevation:Double, latitude:Double, longitude:Double) -> Bool {
        var ret:Bool = false
        let context = getContext()
        let selectRequest:NSFetchRequest<PlaceDescription> = PlaceDescription.fetchRequest()
        selectRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let results = try context.fetch(selectRequest)
            if results.count > 0 {
                let updateObj = results[0] as NSManagedObject
                updateObj.setValue(name, forKey: "name")
                updateObj.setValue(descrip, forKey: "descrip")
                updateObj.setValue(category, forKey: "category")
                updateObj.setValue(address_title, forKey: "address_title")
                updateObj.setValue(address_street, forKey: "address_street")
                updateObj.setValue(elevation, forKey: "elevation")
                updateObj.setValue(latitude, forKey: "latitude")
                updateObj.setValue(longitude, forKey: "longitude")
                do {
                    try context.save()
                    ret = true
                } catch let error as NSError {
                    print("update location failed \(name) error: \(error)")
                    ret = false
                }
            }
        } catch let error as NSError {
            print("error updating location \(name) error: \(error)")
        }
        return ret
    }
    
    class func saveContext() -> Bool {
        var ret:Bool = false
        let context = getContext()
        do{
            try context.save()
            ret = true
        }catch let error as NSError{
            print("error saving context \(error)")
        }
        return ret
    }
    
    class func seedData() {
        
        let checkentries = self.fetchLocationNames()
        if (checkentries?.count)! > 0 {
            return
        }
        
        CoreDataHandler.saveLocation(name:"Nickerson State Park", descrip:"Camping on Cape Cod", category:"State Park", address_title:"Brewster, MA", address_street:"Old Kings Highway", elevation:26.0, latitude:41.7750, longitude:-70.0318)
        
        CoreDataHandler.saveLocation(name:"Mohican State Park", descrip:"Retro Lodge Getaway", category:"State Park", address_title:"Loudonville, OH", address_street:"Route 97", elevation:302.0, latitude:40.613337, longitude:-82.2647)
        
        CoreDataHandler.saveLocation(name:"Red Rocks", descrip:"Epic Concert Venue", category:"Amphitheater", address_title:"Morrison, CO", address_street:"Alameda Parkway", elevation:1950.72, latitude:39.6654, longitude:-105.2057)
        
        CoreDataHandler.saveLocation(name:"Mesa Verde National Park", descrip:"Cliff Dwellings", category:"National Park", address_title:"Mesa Verde, CO", address_street:"Route 10", elevation:2120.29, latitude:37.2309, longitude:-108.4618)
        
        CoreDataHandler.saveLocation(name:"Gates Pass", descrip:"Maginficent Sunsets", category:"Mountain Pass", address_title:"Tucson, AZ", address_street:"West Gates Pass Road", elevation:965.9112, latitude:32.2223, longitude:-111.1009)
    }
    
}
