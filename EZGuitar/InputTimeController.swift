//
//  InputTimeController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/24/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit

class InputTimeController: UIViewController {
    @IBOutlet weak var timeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let destVC = segue.destination as! SummaryController
        // Pass the selected object to the new view controller.
        destVC.inputHours += Double(timeField.text!)!
    }
    

}
