//
//  WCTyphoonDetail.swift
//  WindCatch
//
//  Created by jaben on 2019/9/8.
//  Copyright © 2019 Jaben. All rights reserved.
//

import Foundation

private let directMapping: [String:String] = ["E": "东","W": "西","N": "北","S": "南"]

struct WCTyphoonDetail {
    var id: Int?
    var time: String
    var ts: Int?
    var type: String
    var longitude: Double
    var latitude: Double
    var direct: String?
    var airPress: Int
    var windSpeed: Int
    var moveSpeed: Int?
    
    var directMsg: String {
        var direction = ""
        if let direct = direct {
            let directArray = Array(direct)
            for letter in directArray {
                direction += directMapping["\(letter)"] ?? ""
            }
        }
        return direction
    }
}


