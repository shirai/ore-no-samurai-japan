//
//  PlayerHittingStats.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/14.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

struct PlayerHittingStats: PlayerProtocol {
    /// 背番号
    let no: String?
    /// 選手名
    let name: String
    /// 選手詳細リンク
    let url: URL
    /// チーム
    let team: Team
    /// 打率
    let avg: String
    /// 試合
    let app: String
    /// 打席数
    let tpa: String
    /// 打数
    let ab: String
    /// 安打
    let h: String
    /// 本塁打
    let hr: String
    /// 打点
    let rbi: String
    /// 盗塁
    let sb: String
    /// 四球
    let bb: String
    /// 死球
    let hbp: String
    /// 三振
    let so: String
    /// 犠打
    let sh: String
    /// 併殺打
    let gdp: String
    /// 出塁率
    let obp: String
    /// 長打率
    let slg: String
    /// OPS
    let ops: String
    /// RC27
    let rc27: String
    /// XR27
    let xr27: String
}
extension PlayerHittingStats: CustomStringConvertible {
    var description: String {
        return "打率: \(avg)(出: \(obp)) \(hr)本塁打 \(rbi)打点 \(so)三振 \(sb)盗塁 OPS: \(ops)"
    }    
}
