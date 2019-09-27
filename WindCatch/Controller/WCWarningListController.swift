//
//  WCWarningListController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/17.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit
import AlamofireImage

class WCWarningListController: UITableViewController {
    
    var warningList: [Weather]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Warning"
        self.tableView.tableFooterView = UIView()
        
        weak var weakSelf = self

        WCHttpRequestManager.shareManager.loadWarningListWith { (list, error) in
            if let list = list {
                weakSelf?.warningList = list
                weakSelf?.tableView.reloadData()
            }
        }
        
    }
}

// MARK: - Table view data source
extension WCWarningListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.warningList!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.warningList?[indexPath.row]
        let cell = tableView .dequeueReusableCell(withIdentifier: "warningListCell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let colorView = cell.viewWithTag(2)
        colorView?.backgroundColor = info?.color
        if let info = info {
            titleLabel.text = "\(info.province) \(info.city) [\(info.name)]"
        }
        return cell
    }
}
