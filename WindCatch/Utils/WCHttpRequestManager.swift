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
    
    func loadWarningListWith(completed: @escaping (AnyObject?, Error?)->Void) -> Void {
        //http://typhoon.nmc.cn/weatherservice/fetch_json/warning/json
        Session.default.request("http://typhoon.nmc.cn/weatherservice/fetch_json/warning/json", method: .get, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    guard var responseString = String.init(data: responseData, encoding: .utf8) else {
                        ZBLog("responseData is null")
                        completed(nil, NSError.init(domain: "responseData is null", code: -1, userInfo: nil))
                        return
                    }
                    ZBLog("rawJson\(responseString)")
                    responseString = responseString.replacingOccurrences(of: "fetch_json_warning_json(", with: "")
                    responseString = responseString.replacingOccurrences(of: ")", with: "")
                    
                    guard let responseData = responseString.data(using: .utf8) else {
                        ZBLog("responseString 2 data error")
                        completed(nil, NSError.init(domain: "responseString 2 data error", code: -1, userInfo: nil))
                        return
                    }
                    let list = NSArray.init(object: responseData)
//                    let list = Array(responseData)
                    ZBLog("\(list)")
                    
                }else {
                    
                }
            case.failure(let error):
                completed(nil, error as NSError);
            }
        }
        
    }
    
    func loadTyphoonDetailWith(id: Int, completed: @escaping (WCTyphoon?, Error?)->Void) -> Void {
        let actionName: String = "view_\(id)"
        Session.default.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/\(actionName)", method: .get, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    guard var responseString = String.init(data: responseData, encoding: .utf8) else {
                        ZBLog("responseData is null")
                        completed(nil, NSError.init(domain: "responseData is null", code: -1, userInfo: nil))
                        return
                    }
                    ZBLog("rawJson\(responseString)")
                    responseString = responseString.replacingOccurrences(of: "typhoon_jsons_\(actionName)(", with: "")
                    responseString = responseString.replacingOccurrences(of: ")", with: "")
                    
                    guard let responseData = responseString.data(using: .utf8) else {
                        ZBLog("responseString 2 data error")
                        completed(nil, NSError.init(domain: "responseString 2 data error", code: -1, userInfo: nil))
                        return
                    } 
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                            completed(nil, NSError.init(domain: "Transform ResponseData Format Err", code: -1, userInfo: nil))
                            return
                        }
                        let typhoonsJson: NSArray = json["typhoon"] as! NSArray
                        let model = WCTyphoon();
                        model.updateFrom(json: typhoonsJson)
                        ZBLog(typhoonsJson)
                        completed(model, nil)
                    } catch {
                        completed(nil, error as NSError);
                    }
                }else {
                    completed(nil, NSError.init(domain: "responseData is null", code: -1, userInfo: nil))
                }
            case.failure(let error):
                completed(nil, error as NSError);
            }
        }
    }
    
    func listTyphoonWith(completed: @escaping ([WCTyphoon]?, Error?)->Void) -> Void {
        Session.default.request("http://typhoon.nmc.cn/weatherservice/typhoon/jsons/list_default", method: .get, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    guard var responseString = String.init(data: responseData, encoding: .utf8) else {
                        ZBLog("responseData is null")
                        completed(nil, NSError.init(domain: "responseData is null", code: -1, userInfo: nil))
                        return
                    }
                    ZBLog("rawJson\(responseString)")
                    responseString = responseString.replacingOccurrences(of: "typhoon_jsons_list_default((", with: "")
                    responseString = responseString.replacingOccurrences(of: "))", with: "")
                    
                    guard let responseData = responseString.data(using: .utf8) else {
                        ZBLog("responseString 2 data error")
                        completed(nil, NSError.init(domain: "responseString 2 data error", code: -1, userInfo: nil))
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                            completed(nil, NSError.init(domain: "Transform ResponseData Format Err", code: -1, userInfo: nil))
                            return
                        }
                        let typhoonsJson: NSArray = json["typhoonList"] as! NSArray
                        var result: [WCTyphoon] = []
                        for typhoonJson in typhoonsJson {
                            let model = WCTyphoon();
                            model.updateFrom(json: typhoonJson as! NSArray)
                            result.append(model)
                        }
                        completed(result, nil);
                    } catch {
                        completed(nil, error as NSError);
                    }
                    
                }
            case .failure(let error):
                completed(nil, error as NSError);
            }
        }
    }
}

extension String {
    func count(string: String) -> Int {
        let subString = self.replacingOccurrences(of: string, with: "");
        guard string.count > 0 else {
            return 0
        }
        return (self.count - subString.count) / string.count
    }
    
    func toArray() throws -> [Any] {
        let openCount = self.count(string: "[")
        let closeCount = self.count(string: "]")
        
        guard openCount == closeCount, openCount > 0, closeCount > 0 else {
            throw NSError.init(domain: "Format ERR", code: -1, userInfo: nil)
        }
        
        //self="[[1,3,4], [2,3,4]]"
        let temp = self.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
        if temp.count(string: "[") > 0 {
            let tempArray = self.split(separator: ",")
            var result: [Any] = []
            for subTemp in tempArray {
                let subSting: String = String(subTemp)
                result.append(try subSting.toArray())
            }
            return result
        }else {
            return self.split(separator: ",")
        }
    }
}
