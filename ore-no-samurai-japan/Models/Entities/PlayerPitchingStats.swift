//
//  PlayerPitchingStats.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/15.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

struct PlayerPitchingStats: PlayerProtocol {
    /// 背番号
    let no: String?
    /// 選手名
    let name: String
    /// 選手詳細リンク
    let url: URL
    /// チーム
    let team: Team
    /// 防御率
    let era: String
    /// 試合
    let app: String
    /// 勝利
    let w: String
    /// 敗北
    let l: String
    /// セーブ
    let sv: String
    /// ホールド
    let hld: String
    /// 勝率
    let wpct: String
    /// 打者
    let bf: String
    /// 投球回
    let ip: String
    /// 被安打
    let h: String
    /// 被本塁打
    let hr: String
    /// 与四球
    let bb: String
    /// 与死球
    let hbp: String
    /// 奪三振
    let so: String
    /// 失点
    let r: String
    /// 自責点
    let er: String
    /// WHIP
    let whip: String
    /// DIPS
    let dips: String
}

extension PlayerPitchingStats: CustomStringConvertible {
    var description: String {
        return "\(era) \(app)登板(\(ip)回) \(w)勝\(l)敗\(sv)S \(so)奪三振 WHIP: \(whip)"
    }
}
