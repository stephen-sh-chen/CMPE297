//
//  ViewController.swift
//  SeniorReminder
//
//  Created by Stephen on 11/9/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    var tableView:UITableView?
    
    var uniqueFileName = " senior_reminder.archive"
    var dataFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataFilePath = fileInDocumentsDirectory(filename: uniqueFileName)
        //創建表視圖
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view.addSubview(self.tableView!)
        
        // 在取得提醒之前，需要先獲取授權
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            
            if granted{
                // 獲取授權後，我們可以得到所有的提醒事項
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    
                    self.reminders = reminders
                    print(self.reminders.count)
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var obj:[String] = []
                    for reminder in self.reminders! {
                        if let dueDate = (reminder.dueDateComponents as NSDateComponents?)?.date{
                            obj.append(reminder.title + " - " + formatter.string(from: dueDate) + "\n")
                        } else{
                            obj.append(reminder.title + " - N/A\n")
                        }
                    }
                    NSKeyedArchiver.archiveRootObject(obj, toFile: self.dataFilePath!)
                })
            }else{
                print("獲取提醒失敗！需要授權允許對提醒事項的訪問。")
            }
        }
    }
    
    //在本例中，只有一個分區
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行數（也就是返回控件數）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    //創建各單元顯示內容(創建參數indexPath指定的單元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = UITableViewCell(style: .subtitle,
                                       reuseIdentifier: "myCell")
            let reminder:EKReminder! = self.reminders![indexPath.row]
            
            //提醒事項的內容
            cell.textLabel?.text = reminder.title
            
            //提醒事項的時間
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let dueDate = reminder.dueDateComponents?.date{
                cell.detailTextLabel?.text = formatter.string(from: dueDate)
            }else{
                cell.detailTextLabel?.text = "N/A"
            }
            return cell
    }
    
    @IBAction func viewEvent(_ sender: Any) {
        //let reminders = NSKeyedUnarchiver.unarchiveObject(withFile: dataFilePath!) as! [EKReminder]!
        //self.reminders = reminders
        
        // 在取得提醒之前，需要先獲取授權
        //self.eventStore = EKEventStore()
        //self.reminders = [EKReminder]()
        self.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            
            if granted{
                // 獲取授權後，我們可以得到所有的提醒事項
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    
                    self.reminders = reminders
                    print(self.reminders.count)
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var obj:[String] = []
                    for reminder in self.reminders! {
                        if let dueDate = (reminder.dueDateComponents as NSDateComponents?)?.date{
                            obj.append(reminder.title + " - " + formatter.string(from: dueDate) + "\n")
                        } else{
                            obj.append(reminder.title + " - N/A\n")
                        }
                    }
                    NSKeyedArchiver.archiveRootObject(obj, toFile: self.dataFilePath!)
                })
            }else{
                print("獲取提醒失敗！需要授權允許對提醒事項的訪問。")
            }
        }
        
        self.tableView?.reloadData()
    }
    
    //Helper function to get directory URL
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return documentsFolderPath
    }
    
    //Helper function to get filepath
    func fileInDocumentsDirectory(filename: String) -> String {
        let writePath = (documentsDirectory() as NSString).appendingPathComponent("Mobile")
        //Check file if existing
        if (!FileManager.default.fileExists(atPath: writePath)) {
            do {
                try FileManager.default.createDirectory(atPath: writePath, withIntermediateDirectories: false, attributes: nil) }
            catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return (writePath as NSString).appendingPathComponent(filename)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
