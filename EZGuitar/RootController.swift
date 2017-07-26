//
//  SearchController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/17/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit

class RootController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "somethingSearched", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "somethingSearched" {
            // Get the new view controller using segue.destinationViewController.
            let destVC = segue.destination as! ResultsController
            // Pass the selected object to the new view controller.
            destVC.enteredString = searchBar.text!
            destVC.searchCriteria = segControl.selectedSegmentIndex
        }
    }
 

}
