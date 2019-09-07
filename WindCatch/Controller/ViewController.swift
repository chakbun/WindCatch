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
        
        weak var weakSelf = self
        WCHttpRequestManager.shareManager.listTyphoonWith { (typhoons, error) in
            ZBLog(typhoons)
            weakSelf?.typhoonList = typhoons
            weakSelf?.tableView.reloadData()
        }
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
        nameLabel.text = typhoonModel?.chineseName ?? "Unknow"
        return cell
    }
}

