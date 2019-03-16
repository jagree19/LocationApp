/*
 * DetailViewController.swift
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
 * Purpose: To display and allow editing of a PlaceDescription in the database as per assignment 8 SER423 2018 Spring B
 *
 * @author Justin Greene  mailto:jagree19@asu.edu
 * @version April 2018
 */

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var address_titleField: UITextField!
    @IBOutlet var address_streetField: UITextField!
    @IBOutlet var elevationField: UITextField!
    @IBOutlet var latitudeField: UITextField!
    @IBOutlet var longitudeField: UITextField!
    
    var location: PlaceDescription! {
        didSet {
            navigationItem.title = location.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = location.name
        descriptionField.text = location.descrip
        categoryField.text = location.category
        address_titleField.text = location.address_title
        address_streetField.text = location.address_street
        elevationField.text = "\(location.elevation)"
        latitudeField.text = "\(location.latitude)"
        longitudeField.text = "\(location.longitude)"
    }
    // check for entered text found at http://www.easysolutionweb.com/ios/core-data-insertupdate-and-delete-ios
    @IBAction func saveEditsClicked(_ sender: UIButton) {
        if check(forBlanks: nameField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: descriptionField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: categoryField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: address_titleField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: address_streetField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: elevationField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: latitudeField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        } else  if check(forBlanks: longitudeField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
        }
        let name = nameField.text as? String
        let descrip = descriptionField.text as? String
        let category = categoryField.text as? String
        let address_title = address_titleField.text as? String
        let address_street = address_streetField.text as? String
        let elevationtext = elevationField.text as! String
        let elevation = Double(elevationtext)
        let latitudetext = latitudeField.text as! String
        let latitude = Double(latitudetext)
        let longitudetext = longitudeField.text as! String
        let longitude = Double(longitudetext)
        
        CoreDataHandler.updateLocation(name: name!, descrip: descrip!, category: category!, address_title: address_title!, address_street: address_street!, elevation: elevation!, latitude: latitude!, longitude: longitude!)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // function found at http://www.easysolutionweb.com/ios/core-data-insertupdate-and-delete-ios
    func check(forBlanks textfield: UITextField) -> Bool {
        let rawString:String? = textfield.text
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed:String? = rawString?.trimmingCharacters(in: whitespace)
        if(trimmed?.count ?? 0) == 0 {
            return true
        } else {
            return false
        }
    }
    // function found at http://www.easysolutionweb.com/ios/core-data-insertupdate-and-delete-ios
    func showAlert(withTitleMessageAndAction title:String, message:String, action:Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        if action {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        self.present(alert, animated:true, completion: nil)
    }
}
