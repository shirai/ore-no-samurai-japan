//
//  League.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/10.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

enum League: CaseIterable {
    case central
    case pacific
    
    var name: String {
        switch self {
        case .central: return "セ・リーグ"
        case .pacific: return "パ・リーグ"
        }
    }
    
    var imageURL: URL {
        switch self {
        case .central: return URL(string: "http://p.npb.jp/img/common/logo/flag_central_s.gif")!
        case .pacific: return URL(string: "http://p.npb.jp/img/common/logo/flag_pacific_s.gif")!
        }
    }
}
