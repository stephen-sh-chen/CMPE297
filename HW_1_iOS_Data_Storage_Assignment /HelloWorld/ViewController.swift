//
//  ViewController.swift
//  HelloWorld
//
//  Created by Stephen on 9/12/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
//import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var txfBookName: UITextField!
    @IBOutlet weak var txfAuthorName: UITextField!
    @IBOutlet weak var txvDescription: UITextView!

    func generateString() -> String {
        let str = txfBookName.text! + ", " + txfAuthorName.text! + ", " + txvDescription.text!
        return str
    }
    
    func getDocDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func btnSaveFileStorage(_ sender: Any) {
        // get the documents folder url
        let documentDirectoryURL = getDocDirectory() // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("Assigment1_FileManager.txt")
        print(fileDestinationUrl.path) //print file path
        let text = generateString()
        
        do {
            // writing to disk
            try text.write(to: fileDestinationUrl, atomically: false, encoding: String.Encoding.utf8)
            
            // saving was successful. any code posterior code goes here
            
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileDestinationUrl, encoding: String.Encoding.utf8)
                print(mytext)   // "some text\n"
            } catch let error as NSError {
                print("error loading from url \(String(describing: fileDestinationUrl))")
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("error writing to url \(String(describing: fileDestinationUrl))")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnSaveArchives(_ sender: Any) {
        let text = generateString()
        let data = NSKeyedArchiver.archivedData(withRootObject: text)
        let fullPath = getDocDirectory().appendingPathComponent("Assigment1_Archive.dat")
        print(fullPath.path)
        do {
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }
        

        if let loadedStrings = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.path) {
            print("Read back from Archives: \(loadedStrings)")
        } else {
            print("read back faile!");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello World! I'm Stephen!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

