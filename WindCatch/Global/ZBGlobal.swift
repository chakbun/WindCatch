//
//  ZBGlobal.swift
//  WindCatch
//
//  Created by jaben on 2019/9/4.
//  Copyright © 2019 Jaben. All rights reserved.
//

import Foundation

public func ZBLog<T>(_ message: T, file: String=#file, method: String=#function, line: Int=#line)->Void {
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}
