//
//  ViewController.swift
//  HW5_Map_Kit
//
//  Created by Stephen on 9/22/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fromStreet: UITextField!
    @IBOutlet weak var fromCity: UITextField!
    @IBOutlet weak var fromState: UITextField!
    @IBOutlet weak var fromZipCode: UITextField!
    
    @IBOutlet weak var toStreet: UITextField!
    @IBOutlet weak var toCity: UITextField!
    @IBOutlet weak var toState: UITextField!
    @IBOutlet weak var toZipCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fromPlace = fromStreet.text! + ", " + fromCity.text! + ", " + fromState.text! + ", " + fromZipCode.text! + ", US"
        
        let toPlace = toStreet.text! + ", " + toCity.text! + ", " + toState.text! + ", " + toZipCode.text! + ", US"
        
        if let destinationVC = segue.destination as? MapViewController {
            destinationVC.fromPlace = fromPlace
            destinationVC.toPlace = toPlace
            if segue.identifier == "showMap" { //show Map
                destinationVC.showType = "map"
            } else if segue.identifier == "showRoute" { //show Route
                destinationVC.showType = "route"
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

