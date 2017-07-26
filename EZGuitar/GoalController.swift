//
//  GoalController.swift
//  EZGuitar
//
//  Created by Local Account 436-25 on 7/20/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit

class GoalController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "goalChanged" {
            let destVC = segue.destination as! SummaryController
            
            let newGoal = Goal(name: titleField.text!, goalAmount: Int(hoursField.text!)!, dueDate: datePicker.date)
            destVC.curGoal = newGoal
        }
        // Pass the selected object to the new view controller.
    }
    

}
