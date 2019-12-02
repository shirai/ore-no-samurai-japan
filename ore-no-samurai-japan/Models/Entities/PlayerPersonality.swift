//
//  PlayerPersonality.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/10.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

protocol PlayerProtocol {
    var name: String { get }
    var url: URL { get }
    var team: Team { get }
}

struct PlayerPersonality: PlayerProtocol {
    /// 背番号
    let no: String
    /// 選手名
    let name: String
    /// 選手詳細リンク
    let url: URL
    /// チーム
    let team: Team
    /// 守備
    let position: PositionRegistration
    /// 生年月日
    let birthday: String
    /// 年齢
    let age: String
    /// 年数
    let professionalYears: String
    /// 身長
    let height: String
    /// 体重
    let weight: String
    // TODO: enumかな？
    /// 血液型
    let bloodType: String
    /// 投打(batting/throw)
    let bt: String
    /// 出身地
    let prefectures: String
    /// 年俸(推定/万円)
    let salary: String
}

extension PlayerPersonality: CustomStringConvertible {
    var description: String {
        return "\(bt) \(birthday)(\(age)) 推定年俸: \(salary)"
    }
}
