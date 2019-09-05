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
                    var jsonMsg: String = String.init(data: data, encoding: .utf8) ?? ""
                    jsonMsg = jsonMsg.replacingOccurrences(of: "typhoon_jsons_list_default((", with: "")
                    jsonMsg = jsonMsg.replacingOccurrences(of: "))", with: "")
                    var jsonData = jsonMsg.data(using: .utf8) as! Data
                    do {
                        var responseDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                        print(responseDic)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }


}

