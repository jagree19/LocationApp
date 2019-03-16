 /*
  * AddLocationViewController.swift
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
  * Purpose: To add a new PlaceDescription to the core data database as per assignment 8 SER423 2018 Spring B
  *
  * @author Justin Greene  mailto:jagree19@asu.edu
  * @version April 2018
  */
 
 import UIKit
 import CoreData
 
 class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descripField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var address_titleField: UITextField!
    @IBOutlet weak var address_streetField: UITextField!
    @IBOutlet weak var elevationField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var myScrollView: AdaptiveScrollView!
    
    
    var locations:[PlaceDescription] = [PlaceDescription]()
    var kbHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addLocationClicked(_ sender: UIButton) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func addNewLocation(_ sender: UIButton) {
        if check(forBlanks: nameField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: descripField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: categoryField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: address_titleField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: address_streetField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: elevationField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: latitudeField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        } else  if check(forBlanks: longitudeField) {
            showAlert(withTitleMessageAndAction: "Alert!",message:  "Please enter valid text." , action:false)
            return
        }
        
        let name = nameField.text
        let descrip = descripField.text
        let category = categoryField.text
        let address_title = address_titleField.text
        let address_street = address_streetField.text
        let elevation = Double(elevationField.text as! String)
        let latitude = Double(latitudeField.text as! String)
        let longitude = Double(longitudeField.text as! String)
        
        CoreDataHandler.saveLocation(name: name!, descrip: descrip!, category: category!, address_title: address_title!, address_street: address_street!, elevation: elevation!, latitude: latitude!, longitude: longitude!)
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func editLocation(_ sender: UIButton) {
        
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
