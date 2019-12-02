//
//  ClassNameProtocol.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/18.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
