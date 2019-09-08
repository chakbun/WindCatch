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
    
    func loadTyphoonDetailWith(id: Int, completed: @escaping (WCTyphoon?, NSError?)->Void) -> Void {
        let actionName: String = "view_\(id)"
        Session.default.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/\(actionName)", method: .get, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
            case .success:
                var responseData2String: String = String.init(data: response.data!, encoding: .utf8) ?? ""
//                ZBLog("rawJson\(responseData2String)")
                responseData2String = responseData2String.replacingOccurrences(of: "typhoon_jsons_\(actionName)(", with: "")
                responseData2String = responseData2String.replacingOccurrences(of: ")", with: "")
                let responseDataAfterFilter = responseData2String.data(using: .utf8)
                if let resData = responseDataAfterFilter {
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: resData, options: []) as? [String: Any]
                        if let jsonDic = jsonDictionary {
                            let typhoonsJson: NSArray = jsonDic["typhoon"] as! NSArray
                            let model = WCTyphoon();
                            model.updateFrom(json: typhoonsJson)
                            ZBLog(typhoonsJson)
                            completed(model, nil)
                        }else {
                            completed(nil, NSError.init(domain: "Transform ResponseData Format Err", code: -1, userInfo: nil));
                        }
                    } catch {
                        completed(nil, error as NSError);
                    }
                }else {
                    completed(nil, NSError.init(domain: "ResponseData Format Err", code: -2, userInfo: nil));
                }

            case.failure(let error):
                completed(nil, error as NSError);
            }
        }
    }
    
    func listTyphoonWith(completed: @escaping ([WCTyphoon]?, NSError?)->Void) -> Void {
        Session.default.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/list_default", method: .get, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    var responseData2String: String = String.init(data: responseData, encoding: .utf8) ?? ""
                    ZBLog("rawJson\(responseData2String)")
                    responseData2String = responseData2String.replacingOccurrences(of: "typhoon_jsons_list_default((", with: "")
                    responseData2String = responseData2String.replacingOccurrences(of: "))", with: "")
                    let responseDataAfterFilter = responseData2String.data(using: .utf8)
                    
                    if let resData = responseDataAfterFilter {
                        do {
                            let jsonDictionary = try JSONSerialization.jsonObject(with: resData, options: []) as? [String: Any]
                            if let jsonDic = jsonDictionary {
                                let typhoonsJson: NSArray = jsonDic["typhoonList"] as! NSArray
                                var result: [WCTyphoon] = []
                                for typhoonJson in typhoonsJson {
                                    let model = WCTyphoon();
                                    model.updateFrom(json: typhoonJson as! NSArray)
                                    result.append(model)
                                }
                                completed(result, nil);
                            }else {
                                completed(nil, NSError.init(domain: "Transform ResponseData Format Err", code: -1, userInfo: nil));
                            }
                        } catch {
                            completed(nil, error as NSError);
                        }
                    }else {
                        completed(nil, NSError.init(domain: "ResponseData Format Err", code: -2, userInfo: nil));
                    }
                    
                }
            case .failure(let error):
                completed(nil, error as NSError);
            }
        }
    }

}
