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
    
        AF.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/list_default", method: .get, encoding: URLEncoding.default).responseString { (responseString) in
            switch responseString.result {
            case .success:
                if let data = responseString.data {
                    var jsonMsg = String.init(data: data, encoding: .utf8) as? String
                    print(jsonMsg);
                }
            case let .failure(error):
                print(error)
            }
        }
    }


}

