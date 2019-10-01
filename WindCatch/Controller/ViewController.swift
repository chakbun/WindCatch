//
//  ViewController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/4.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UITableViewController {
    
    var typhoonList: [WCTyphoon]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        weak var weakSelf = self
        WCHttpRequestManager.shareManager.listTyphoonWith { (typhoons, error) in
            weakSelf?.typhoonList = typhoons
            weakSelf?.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        
        if controller is WCMapController {
            let mapController: WCMapController = controller as! WCMapController
            mapController.typhoon = sender as? WCTyphoon
        }
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showWarningSegue", sender: nil)
    }
}

// MARK: - TableView Data Source
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typhoonList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typhoonModel = self.typhoonList?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WCTyphoonListCell", for: indexPath)
        let nameLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let stateView: UIView = cell.viewWithTag(2)!
        let nameText = typhoonModel?.chineseName ?? "Unknow"
        let indexText = typhoonModel?.noString ?? "Unknow"
        nameLabel.text = nameText + "[\(indexText)]"
        if typhoonModel?.status == "start" {
            stateView.backgroundColor = UIColor(red: 100/255.0, green: 202/255.0, blue: 87/255.0, alpha: 1.0)
        }else {
            stateView.backgroundColor = UIColor(red: 237/255.0, green: 107/255.0, blue: 96/255.0, alpha: 1.0)
        }
        return cell
    }
}

// MARK: - TableView Delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typhoonModel = self.typhoonList?[indexPath.row]
        self .performSegue(withIdentifier: "showMapSegue", sender: typhoonModel)
    }
}

