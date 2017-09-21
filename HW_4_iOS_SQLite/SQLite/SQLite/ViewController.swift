//
//  ViewController.swift
//  SQLite
//
//  Created by Stephen on 9/18/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var databasePath:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        databasePath = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("contacts.db")
        
        let database = FMDatabase(url: databasePath)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        
        let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, LOCATION TEXT, ADDRESS TEXT, PHONE TEXT, EMAIL TEXT)"
        
        guard database.executeStatements(sql_stmt) else {
            print("Error: \(database.lastErrorMessage())")
            return
        }
    }

    @IBAction func save(_ sender: Any) {
        let database = FMDatabase(url: databasePath)
        
        guard database.open() else {
            print("Unable to open database")
            print("Error: \(database.lastErrorMessage())")
            status.text = "Unable to open database"
            return
        }
        
        let insertSQL = "INSERT INTO CONTACTS (name, location, address, phone, email) VALUES ('\(name.text!)', '\(location.text!)', '\(address.text!)', '\(phone.text!)', '\(email.text!)')"
        
        do {
            try database.executeUpdate(insertSQL, values: nil)
            status.text = "Contact Added"
            name.text = ""
            location.text = ""
            address.text = ""
            phone.text = ""
            email.text = ""
        } catch {
            print("failed: \(error.localizedDescription)")
            print("Failed to add contact")
            print("Error: \(database.lastErrorMessage())")
            status.text = "Failed to add contact"
        }
        database.close()
    }
    
    @IBAction func cancel(_ sender: Any) {
        status.text = "status will show here"
        name.text = ""
        location.text = ""
        address.text = ""
        phone.text = ""
        email.text = ""
    }
    
    @IBAction func find(_ sender: Any) {
        let database = FMDatabase(url: databasePath)
        
        guard database.open() else {
            print("Unable to open database")
            print("Error: \(database.lastErrorMessage())")
            status.text = "Unable to open database"
            return
        }
        
        let querySQL = "SELECT location, address, phone, email FROM CONTACTS WHERE name = '\(name.text!)'"
        
        do {
            let rs = try database.executeQuery(querySQL, values: nil)
            if rs.next() {
                if let w = rs.string(forColumn: "location"), let x = rs.string(forColumn: "address"), let y = rs.string(forColumn: "phone") , let z = rs.string(forColumn: "email") {
                    location.text = w
                    address.text = x
                    phone.text = y
                    email.text = z
                    status.text = "Found!"
                }
            } else {
                status.text = "Not Found!"
                location.text = ""
                address.text = ""
                phone.text = ""
                email.text = ""
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            print("Error: \(database.lastErrorMessage())")
        }
        database.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

