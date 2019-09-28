//
//  Weather.swift
//  WindCatch
//
//  Created by jaben on 2019/9/25.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit

struct Weather {
    var province: String
    var city: String
    var name: String
    var colorMsg: String
    var timeMsg: String
    var imageName: String
    var info: String
    var latitude: Double
    var longitude: Double
    
    var color: UIColor {
        switch colorMsg {
        case "红色":
            return UIColor(red: 198/255.0, green: 63/255.0, blue: 50/255.0, alpha: 1.0)
        case "黄色":
            return UIColor(red: 248/255.0, green: 236/255.0, blue: 87/255.0, alpha: 1.0)
        case "橙色":
            return UIColor(red: 235/255.0, green: 144/255.0, blue: 61/255.0, alpha: 1.0)
        case "蓝色":
            return UIColor(red: 59/255.0, green: 105/255.0, blue: 245/255.0, alpha: 1.0)
        default:
            return .black
        }
    }
}
