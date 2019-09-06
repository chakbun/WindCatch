//
//  WCHttpRequestManager.swift
//  WindCatch
//
//  Created by jaben on 2019/9/6.
//  Copyright © 2019 Jaben. All rights reserved.
//

import Foundation
import Alamofire

class WCHttpRequestManager {
    static let shareManager: WCHttpRequestManager = WCHttpRequestManager()
    
    func listTyphoonWith(completed: @escaping ([WCTyphoon]?, NSError?)->Void) -> Void {
        Session.default.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/list_default", method: .get, encoding: URLEncoding.default).responseString { (responseString) in
            switch responseString.result {
            case .success:
                if let data = responseString.data {
                    var jsonMsg: String = String.init(data: data, encoding: .utf8) ?? ""
                    jsonMsg = jsonMsg.replacingOccurrences(of: "typhoon_jsons_list_default((", with: "")
                    jsonMsg = jsonMsg.replacingOccurrences(of: "))", with: "")
                    let jsonData: Data = jsonMsg.data(using: .utf8) as! Data
                    do {
                        let responseDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                        if let responseJson = responseDic {
                            let typhoonsJson: NSArray = responseJson["typhoonList"] as! NSArray
                            var result: [WCTyphoon] = []
                            for typhoonJson in typhoonsJson {
                                var model = WCTyphoon();
                                model.updateFrom(json: typhoonJson as! NSArray)
                                result.append(model)
                            }
                            completed(result, nil);
                        }else {
                            completed(nil, NSError.init(domain: "Err", code: -1, userInfo: nil));
                        }
                    } catch {
                        completed(nil, error as NSError);
                    }
                }
            case let .failure(error):
                completed(nil, error as NSError);
            }
        }
    }

}
