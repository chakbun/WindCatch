//
//  WCTyphoon.swift
//  WindCatch
//
//  Created by jaben on 2019/9/6.
//  Copyright © 2019 Jaben. All rights reserved.
//

import Foundation

class WCTyphoon {
    var id: Int
    var name: String
    var chineseName: String?
    var no: Int?
    var noString: String?
    var fullNo: Int?
    var nameDescription: String?
    var status: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init() {
        self.init(id: -1, name: "empty")
    }
    
    func updateFrom(json: NSArray) -> Void {
        guard json.count == 8 else {
            ZBLog("json format Error")
            return
        }
        self.id = json[0] as! Int
        self.name = json[1] as! String
        self.chineseName = json[2] as? String
        self.no = json[3] as? Int
        self.noString = json[4] as? String
        self.fullNo = json[5] as? Int
        self.nameDescription = json[6] as? String
        self.status = json[7] as? String
    }
}
