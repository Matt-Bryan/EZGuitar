//
//  ResultsController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/17/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit

class ResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var resultsForLabel: UILabel!
    
    var searchCriteria = -1
    
    var enteredString = ""
    
    let guitarPartySongs = "http://api.guitarparty.com/v2/songs/?query="
    
    let guitarPartyArtists = "http://api.guitarparty.com/v2/artists/?query="
    
    var searchString = ""
    
    let key = "2e14a05149c31c3258fddebb37bcef98e95698bd"
    
    var swifty : JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsForLabel.text = "Results for \(enteredString)..."
        enteredString = enteredString.replacingOccurrences(of: " ", with: "+")
        
        if searchCriteria == 0 {
            //Searching for Songs
            searchString = "\(guitarPartySongs)\(enteredString)"
            search()
        }
        else if searchCriteria == 1 {
            //Searching for Artists
            searchString = "\(guitarPartyArtists)\(enteredString)"
            search()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: URL(string: searchString)!)
        
        request.setValue(key, forHTTPHeaderField: "Guitarparty-Api-Key")
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            
            
            if let data = receivedData {
                self.swifty = JSON(data)
                //self.swiftyDrillDown(json: self.swifty!, indent: "")
//                let rawDataString = String(data: data, encoding: String.Encoding.utf8)
//                print(rawDataString!)
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyResultsCell") as? MyResultsCell
        
        if searchCriteria == 0 {
            //Songs
            cell?.nameLabel.text = swifty?["objects"][indexPath.row]["title"].string ?? "Didn't work"
        }
        else if searchCriteria == 1 {
            //Artists
            cell?.nameLabel.text = swifty?["objects"][indexPath.row]["name"].string ?? "Didn't work"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swifty?["objects_count"].int ?? 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "moreResultDetail" {
            let destVC = segue.destination as! ResultsDetailController
            if searchCriteria == 0 {
                //Song
                destVC.titleText = (swifty?["objects"][(myTableView.indexPathForSelectedRow?.row)!]["title"].string) ?? "Whoops, that didn't work"
                destVC.bodyText = (swifty?["objects"][(myTableView.indexPathForSelectedRow?.row)!]["body"].string) ?? "Sorry about that"
            }
            else {
                //Arist
                destVC.titleText = swifty?["objects"][(myTableView.indexPathForSelectedRow?.row)!]["name"].string ?? "Whoops, that didn't work"
                destVC.bodyText = swifty?["objects"][(myTableView.indexPathForSelectedRow?.row)!]["bio"].string ?? "Sorry about that"
            }
        }
        // Pass the selected object to the new view controller.
    }
    
    func swiftyDrillDown(json : JSON, indent: String) {
        
        let ourIndent = indent + "\t"
        let type = json.type
        
        if type == .dictionary {
            for (key, value):(String,JSON) in json {
                if value.type == .dictionary {
                    print("\(ourIndent)\(key) is a dictionary ->")
                    swiftyDrillDown(json: value, indent: ourIndent)
                } else if value.type == .array {
                    let array = value.arrayValue
                    let first = array.first
                    if first?.type == .dictionary {
                        print("\(ourIndent)\(key) array -> type is a dictionary ->")
                        swiftyDrillDown(json: first!, indent: ourIndent)
                    }
                } else {
                    print("\(ourIndent)\(key) : \(value.type)")
                }
            }
        } else {
            print("\(ourIndent)type: \(json.type)")
        }
    }
}
