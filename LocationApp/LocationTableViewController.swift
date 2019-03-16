/*
 * LocationTableViewController.swift
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
 * Purpose: To display a list of names of PlaceDescriptions that are in the database,
 *          also allows the deletion of a PlaceDescription by entering editing mode,
 *          also is the initial view and leads to other parts of the application as per assignment 8 SER423 2018 Spring B
 *
 * @author Justin Greene  mailto:jagree19@asu.edu
 * @version April 2018
 */

import UIKit
import CoreData

class LocationTableViewController: UITableViewController {
    
    var locations:[PlaceDescription] = [PlaceDescription]()
    var locNames:[String] = [String]()
    
    @IBOutlet var addLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataHandler.seedData()
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit Library", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locNames = CoreDataHandler.fetchLocationNames()!
        return locNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locCell", for: indexPath)
        locations = CoreDataHandler.fetchLocations()!
        let locale = locations[indexPath.row]
        cell.textLabel?.text = locale.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //If table view is asking to commit a delete command
        if editingStyle == .delete {
            let item = locations[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                CoreDataHandler.deleteLocation(name: item.name!)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                CoreDataHandler.saveContext()
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = locations[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.location = item
            }
        case "addLocation":
            let addLocationViewController = segue.destination as! AddLocationViewController
            addLocationViewController.locations = locations
        case "calculate":
            let calculationsViewController = segue.destination as! CalculationsViewController
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}
