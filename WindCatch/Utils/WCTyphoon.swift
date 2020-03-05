//
//  WCTyphoon.swift
//  WindCatch
//
//  Created by jaben on 2019/9/6.
//  Copyright © 2019 Jaben. All rights reserved.
//

import Foundation
import MapKit



class WCTyphoon {
    var id: Int
    var name: String
    var chineseName: String?
    var no: Int?
    var noString: String?
    var fullNo: Int?
    var nameDescription: String?
    var status: String?
    var details: [WCTyphoonDetail]?
    
    var coordinateArray: [CLLocationCoordinate2D]? {
        if let details = details {
            var array: [CLLocationCoordinate2D] = []
            for detail in details {
                array.append(CLLocationCoordinate2D.init(latitude: detail.latitude, longitude: detail.longitude))
            }
            return array
        }else {
            return nil
        }
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init() {
        self.init(id: -1, name: "empty")
    }
    
    func updateFrom(json: NSArray) -> Void {
        guard json.count >= 8 else {
            ZBLog("json format Error")
            return
        }
        self.id = json[0] as! Int
        self.name = json[1] as! String
        self.chineseName = json[2] as? String
        self.no = json[3] as? Int
        self.noString = "\(json[4])"
        self.fullNo = json[5] as? Int
        self.nameDescription = json[6] as? String
        self.status = json[7] as? String
        
        guard json.count > 8 else {
            return
        }
        
        var detailsList: [WCTyphoonDetail] = []
        let detailJson = json[8] as? NSArray
        for detail in detailJson! {
            let array = detail as! NSArray
            let dID = array[0] as! Int
            let time = array[1] as! String
            let ts = array[2] as! Int
            let type = array[3] as! String
            let longitude = array[4] as! Double
            let latitude = array[5] as! Double
            let press = array[6] as! Int
            let windspeed = array[7] as! Int
            let direct = array[8] as! String
            let moveSpeed = array[9] as! Int
            
            var model = WCTyphoonDetail.init(id: dID, time: time, ts: ts, type: type, longitude: longitude, latitude: latitude, direct: direct, airPress: press, windSpeed: windspeed, moveSpeed: moveSpeed, predictArray: [])
            
            let predictJsonOp = array[11] as? NSDictionary
            
            if let predictJson = predictJsonOp {
                let predictArray = predictJson["BABJ"] as! NSArray
                for predictInfo in predictArray {
                    let predictModel = predictInfo as! NSArray
                    let hourLater = predictModel[0] as! Int
                    let preLongitude = predictModel[2] as! Double
                    let preLatitude = predictModel[3] as! Double
                    let prePress = predictModel[4] as! Int
                    let preWindspeed = predictModel[5] as? Int ?? 1
                    let preType = predictModel[7] as! String
                    let preModel = WCTyphoonDetail.init(id: nil, time: "", ts: nil, type: preType, longitude: preLongitude, latitude: preLatitude, direct: nil, airPress: prePress, windSpeed: preWindspeed, moveSpeed: nil, predictArray: nil)
                    model.predictArray?.append(preModel)
                }
                detailsList.append(model)
            }else {
                ZBLog("predictJsonOp is null")
            }
        }
        self.details = detailsList
    }
}
