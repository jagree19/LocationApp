/*
 * CalculationsViewController.swift
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
 * Purpose: To calculate great circle distance and initial bearing as per assignment 8 SER423 2018 Spring B
 *
 * @author Justin Greene  mailto:jagree19@asu.edu
 * @version April 2018
 */

import UIKit
import CoreData

class CalculationsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var place1Picker: UIPickerView!
    @IBOutlet var place2Picker: UIPickerView!
    
    @IBOutlet var gcdistField: UITextField!
    @IBOutlet var initbearField: UITextField!
    
    var placeNames:[String] = [String]()
    var locations:[PlaceDescription] = [PlaceDescription]()
    
    var place1Latitude:Double! = 0.00
    var place1Longitude:Double! = 0.00
    var place2Latitude:Double! = 0.00
    var place2Longitude:Double! = 0.00
    
    var phi1:Double!
    var phi2:Double!
    var lam1:Double!
    var lam2:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Calculations"
        
        self.place1Picker.delegate = self
        self.place1Picker.dataSource = self
        self.place2Picker.delegate = self
        self.place2Picker.dataSource = self
        
        placeNames = CoreDataHandler.fetchLocationNames()!
        
        // initialize latitude and longitude values with the data for the first entry on the pickers
        
        let name1 = self.placeNames[0]
        var locale1:PlaceDescription = CoreDataHandler.fetchLocation(name1)
        place1Latitude = locale1.latitude
        place1Longitude = locale1.longitude
        
        let name2 = self.placeNames[0]
        var locale2:PlaceDescription = CoreDataHandler.fetchLocation(name2)
        place2Latitude = locale2.latitude
        place2Longitude = locale2.longitude
        
    }
    
    func convertToRad(fromLat: Double, fromLong: Double, toLat:Double, toLong: Double) {
        
        let degToRad = .pi / 180.0
        phi1 = fromLat * degToRad
        phi2 = toLat * degToRad
        lam1 = fromLong * degToRad
        lam2 = toLong * degToRad
    }
    
    func calculateGreatCircle(phi1: Double, lam1: Double, phi2:Double, lam2: Double) -> Double {
        
        let gc = 6371.01 * acos(sin(phi1)*sin(phi2)+cos(phi1)*cos(phi2)*cos(lam2-lam1))
        
        return gc
    }
    
    func calculateInitialBearing(phi1: Double, lam1:Double, phi2:Double, lam2:Double) -> Double {
        
        let y = sin(lam2-lam1)*cos(phi2)
        let x = cos(phi1)*sin(phi2)-sin(phi1)*cos(phi2)*cos(lam2-lam1)
        let z = (atan2(y,x)*180 / .pi)
        let q = z + 360.0
        let initialBearing = q.truncatingRemainder(dividingBy: 360.0)
        return initialBearing
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == place1Picker) {
            let name = self.placeNames[row]
            var locale1:PlaceDescription = CoreDataHandler.fetchLocation(name)
            place1Latitude = locale1.latitude
            place1Longitude = locale1.longitude
            
            /*  //for initial testing
             let lat = String(place1Latitude)
             self.gcdistField.text = lat
             */
        }
        
        if(pickerView == place2Picker) {
            let name = self.placeNames[row]
            var locale2:PlaceDescription = CoreDataHandler.fetchLocation(name)
            place2Latitude = locale2.latitude
            place2Longitude = locale2.longitude
            
            /*  //for initial testing
             let long = String(place2Longitude)
             self.initbearField.text = long
             */
        }
    }
    
    
    @IBAction func calcButtonClicked(_ sender: UIButton) {
        
        convertToRad(fromLat: place1Latitude, fromLong: place1Longitude, toLat: place2Latitude, toLong: place2Longitude)
        let greatcircleDouble = calculateGreatCircle(phi1: phi1, lam1: lam1, phi2: phi2, lam2: lam2)
        let initialBearingDouble = calculateInitialBearing(phi1: phi1, lam1: lam1, phi2: phi2, lam2: lam2)
        gcdistField.text = String(format: "%.5f", greatcircleDouble)
        initbearField.text = String(format: "%.5f", initialBearingDouble)
        
        print("Place 1  \(place1Latitude), \(place1Longitude)")
        print("Place 2 \(place2Latitude), \(place2Longitude)")
        
    }
    
}
