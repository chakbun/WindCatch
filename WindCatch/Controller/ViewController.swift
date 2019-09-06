//
//  ViewController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/4.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WCHttpRequestManager.shareManager.listTyphoonWith { (typhoons, error) in
            ZBLog(typhoons)
        }
    }


}

