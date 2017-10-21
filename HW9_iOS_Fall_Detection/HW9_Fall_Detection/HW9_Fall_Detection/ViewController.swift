//
//  ViewController.swift
//  HW9_Fall_Detection
//
//  Created by Stephen on 10/20/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
import CoreMotion
//import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    var myMotionManager = CMMotionManager()
    var isFall = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myMotionManager.gyroUpdateInterval = 0.2
        myMotionManager.accelerometerUpdateInterval = 0.2
        myMotionManager.deviceMotionUpdateInterval = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startDetect(_ sender: Any) {
        self.statusLabel.text = "Detecting..."
        myMotionManager.startAccelerometerUpdates(to: OperationQueue()) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            let acceleration = accelerometerData!.acceleration
            let a = pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2)
            print(a)
            //By theory, if a drop to 0, mean phone is dropping
            DispatchQueue.main.async(execute: { () -> Void in
                if (a < 0.1) {
                    self.statusLabel.text = "Detected"
                    print("Detect phone fall...")
                    self.myMotionManager.stopAccelerometerUpdates()
                } else {
                    //phone not drop
                }
            })
            if(NSError != nil) {
                print("\(String(describing: NSError))")
            }
        }
    }
    
    @IBAction func stopDetected(_ sender: Any) {
        statusLabel.text = "Not Detected"
        myMotionManager.stopAccelerometerUpdates() //Stop update
    }
    
}

