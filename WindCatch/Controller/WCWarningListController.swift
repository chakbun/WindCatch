//
//  WCWarningListController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/17.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit

class WCWarningListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Warning"
        
        WCHttpRequestManager.shareManager.loadWarningListWith { (list, error) in
            
        }
        
    }
}

// MARK: - Table view data source
extension WCWarningListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
