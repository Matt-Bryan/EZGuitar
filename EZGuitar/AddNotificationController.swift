//
//  AddNotificationController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/19/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class AddNotificationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var numField: UITextField!
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    let hourSeconds = 3600
    let daySeconds = 86400
    let weekSeconds = 604800
    var monthSeconds = -1
    var yearSeconds = -1
    
    var center : UNUserNotificationCenter?
    
    //var eventStore: EKEventStore!
    
    let intervals : [String] = ["Minutes", "Hours", "Days", "Weeks", "Months", "Years"]

    override func viewDidLoad() {
        super.viewDidLoad()
        monthSeconds = weekSeconds * 4
        yearSeconds = monthSeconds * 12
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return intervals[row]
    }
    
    func determineInterval(numIntervals: Int) -> TimeInterval{
        var num = -1
        
        switch intervalPicker.selectedRow(inComponent: 0) {
        case 0:
            num = 60
            break
        case 1:
            num = hourSeconds
            break
        case 2:
            num = daySeconds
            break
        case 3:
            num = weekSeconds
            break
        case 4:
            num = monthSeconds
            break
        case 5:
            num = yearSeconds
            break
        default:
            num = 60
            break
        }
        
        return TimeInterval(num * numIntervals)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let destVC = segue.destination as! SummaryController
        // Pass the selected object to the new view controller.
        if segue.identifier == "createButtonClicked" {
            if numField.text != "" {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: titleField.text ?? "No Title Specified", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Custom reminder created in EZGuitar", arguments: nil)
                
                let numIntervals = Int(numField.text!)!
                let interval = determineInterval(numIntervals: numIntervals)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
                let notification = UNNotificationRequest(identifier: titleField.text ?? "Default Identifier", content: content, trigger: trigger)
                center?.add(notification) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }
                destVC.pendingNotifications.append(notification)
            }
        }
    }
}
