//
//  SummaryController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/17/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class SummaryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var goalHoursLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var curGoalLabel: UILabel!
    @IBOutlet weak var curGoalTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var center : UNUserNotificationCenter?
    
    var pendingNotifications : [UNNotificationRequest]!
    
    var inputHours = 0.0
    var goalHours = 0
    
    var curGoal : Goal?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        center = UNUserNotificationCenter.current()
        
        // Uncomment the following method call to remove all pending notifications
        // *** THIS WILL REMOVE ALL NOTIFICATIONS FROM OTHER APPS TOO ***
        //center?.removeAllPendingNotificationRequests()
        
        pendingNotifications = [UNNotificationRequest]()
        center?.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
            if granted {
                self.center?.getPendingNotificationRequests(completionHandler: { requests in
                    for request in requests {
                        self.pendingNotifications.append(request)
                    }
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                })
            }
            else {
                print("The app is not permitted to access notifications, make sure to grant permission in the settings and try again")
            }
        }
        //Load a goal if one exists in persistent storage
        loadGoal()
        
        if curGoal == nil {
            curGoalLabel.text = "Play X Hours by XX/XX/XXXX"
        }
        else {
            printGoalLabels()
        }
        inputLabel.text = String(inputHours)
        goalHoursLabel.text = String(goalHours)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.reminders.count
        return self.pendingNotifications.count
    }
    
    func loadGoal() {
        let newName = userDefaults.string(forKey: "goalName")
        let newAmount = userDefaults.integer(forKey: "goalAmount")
        let newDate = userDefaults.object(forKey: "goalDate") as! Date
        curGoal = Goal(name: newName!, goalAmount: newAmount, dueDate: newDate)
        goalHours = newAmount
        inputHours = userDefaults.double(forKey: "inputHours")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationCell") as? MyNotificationCell
        let currentNotification : UNNotificationRequest = self.pendingNotifications[indexPath.row]
        cell?.titleLabel?.text = currentNotification.content.title
    
        let curTrigger = currentNotification.trigger as! UNTimeIntervalNotificationTrigger
        //cell?.nextDateLabel.text = String(describing: curTrigger.nextTriggerDate())
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        cell?.nextDateLabel.text = dateFormatter.string(from: curTrigger.nextTriggerDate()!)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        cell?.nextTimeLabel.text = dateFormatter.string(from: curTrigger.nextTriggerDate()!)
        
        return cell!
    }
    
    @IBAction func unwindFromDetail(segue:UIStoryboardSegue) {
        if segue.identifier == "createButtonClicked" {
            myTableView.reloadData()
        }
        else if segue.identifier == "goalChanged" {
            if curGoal == nil {
                curGoalLabel.text = "Play X Hours by XXX XX, XXXX"
                curGoalTitleLabel.text = "My Current Goal"
            }
            else {
                printGoalLabels()
                userDefaults.set(curGoal?.name, forKey: "goalName")
                userDefaults.set(curGoal?.goalAmount, forKey: "goalAmount")
                userDefaults.set(curGoal?.dueDate, forKey: "goalDate")
            }
        }
        inputLabel.text = String(inputHours)
        userDefaults.set(inputHours, forKey: "inputHours")
    }
    
    func printGoalLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        curGoalLabel.text = "Play \(curGoal!.goalAmount) Hours by \(dateFormatter.string(from: curGoal!.dueDate))"
        curGoalTitleLabel.text = curGoal?.name
        goalHoursLabel.text = String(curGoal!.goalAmount)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "addNotification" {
            let destVC = segue.destination as! AddNotificationController
            destVC.center = center!
        }
        myTableView.setEditing(false, animated: false)
        // Pass the selected object to the new view controller.
    }
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = myTableView.cellForRow(at: indexPath) as! MyNotificationCell
            //tableView.deleteRows(at: [indexPath], with: .fade)
            center?.removePendingNotificationRequests(withIdentifiers: [cell.titleLabel.text!])
            pendingNotifications.remove(at: indexPath.row)
            myTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        if myTableView.isEditing {
            editButton.setTitle("Done", for: .normal)
        }
        else {
            editButton.setTitle("Edit", for: .normal)
        }
    }

}
