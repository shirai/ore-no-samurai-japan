//
//  Position.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/14.
//  Copyright © 2019 白井　誠. All rights reserved.
//

enum Position: Int, CaseIterable {
    case starter
    case reliever
    case closer
    case catcher
    case first
    case second
    case third
    case shortstop
    case left
    case center
    case right
    case dh
    case undefined
    
    func positionName() -> String {
        switch self {
        case .starter:
            return "先発投手"
        case .reliever:
            return "中継ぎ投手"
        case .closer:
            return "抑え投手"
        case .catcher:
            return "捕手"
        case .first:
            return "一塁手"
        case .second:
            return "二塁手"
        case .third:
            return "三塁手"
        case .shortstop:
            return "遊撃手"
        case .left:
            return "左翼手"
        case .center:
            return "中堅手"
        case .right:
            return "右翼手"
        case .dh:
            return "DH"
        case .undefined:
            return "獲得選手"
        }
    }
}

enum PositionRegistration: String, CaseIterable {
    case pitcher = "投手"
    case catcher = "捕手"
    case infielder = "内野手"
    case outfielder = "外野手"
}
