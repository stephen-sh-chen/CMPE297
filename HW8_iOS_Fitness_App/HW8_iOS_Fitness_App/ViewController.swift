//
//  ViewController.swift
//  HW8_iOS_Fitness_App
//
//  Created by Stephen on 10/12/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var floorAscend: UILabel!
    @IBOutlet weak var floorDescend: UILabel!
    @IBOutlet weak var distanceMeter: UILabel!
    
    let myMotionActivityManager = CMMotionActivityManager()
    let myPedometer = CMPedometer()
    var myTimer: Timer!
    var initialStartDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startMotionSensing() {
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isFloorCountingAvailable()) {
            print("support step count and floor count...")
            if initialStartDate == nil {
                initialStartDate = NSDate(timeIntervalSinceNow: -(1 * 60 * 60)) //1 hour ago
            }
            myPedometer.startUpdates(from: initialStartDate! as Date, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                print("check updating...")
                if error != nil {
                    print("There was an error obtaining pedometer data: \(error!)")
                } else {
                    print("Start counting...")
                    print(data)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.floorAscend.text = "\(data.floorsAscended!)"
                        self.floorDescend.text = "\(data.floorsDescended!)"
                        self.stepCount.text = "\(data.numberOfSteps)"
                        var distance = data.distance?.doubleValue
                        distance = Double(round(100 * distance!) / 100)
                        self.distanceMeter.text = "\(distance!)"
                    })
                }
            })
        } else {
            print("Step count is not available")
        }
    }

    @IBAction func startWorkout(_ sender: Any) {
        if initialStartDate == nil {
            initialStartDate = NSDate()
        }
        print("Start Sensing ...")
        myTimer = Timer.scheduledTimer(timeInterval: 2.0,
                                       target: self,
                                       selector: #selector(self.startMotionSensing),
                                       userInfo:nil, repeats: true)
        print(myTimer)
    }
    
    
    @IBAction func stopWorkout(_ sender: Any) {
        print("Stop Sensing...")
        self.myTimer.invalidate()
        myPedometer.stopUpdates()
    }
}

