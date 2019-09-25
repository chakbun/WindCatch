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
    
    var color: UIColor {
        switch colorMsg {
        case "红色":
            return UIColor(red: 198/255.0, green: 60/255.0, blue: 47/255.0, alpha: 1.0)
        case "黄色":
            return UIColor(red: 246/255.0, green: 191/255.0, blue: 80/255.0, alpha: 1.0)
        case "橙色":
            return UIColor(red: 241/255.0, green: 157/255.0, blue: 56/255.0, alpha: 1.0)
        case "蓝色":
            return UIColor(red: 64/255.0, green: 103/255.0, blue: 236/255.0, alpha: 1.0)
        default:
            return .black
        }
    }
}
