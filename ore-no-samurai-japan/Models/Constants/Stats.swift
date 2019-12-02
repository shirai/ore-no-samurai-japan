//
//  Stats.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/10.
//  Copyright © 2019 白井　誠. All rights reserved.
//

/// 選手成績種別
enum Stats {
    case hitter(HitterStatsType?)
    case pitcher(PitcherStatsType?)
    
    /// 打者成績種別
    enum HitterStatsType: String {
        /// 打率
        case avg
        /// 本塁打
        case hr
        /// 打点
        case rbi
        /// 盗塁
        case sb
        
        var name: String {
            switch self {
            case .avg:  return "打率"
            case .hr:   return "本塁打"
            case .rbi:  return "打点"
            case .sb:   return "盗塁"
            }
        }
    }
    
    /// 投手成績種別
    enum PitcherStatsType: String {
        /// 防御率
        case era
        /// 勝利数
        case win
        /// 奪三振
        case so
        /// セーブ
        case save
        
        var name: String {
            switch self {
            case .era:  return "防御率"
            case .win:  return "勝利数"
            case .so:   return "奪三振"
            case .save: return "セーブ"
            }
        }
    }
    
    var name: String {
        switch self {
        case .hitter:  return "打者成績"
        case .pitcher: return "投手成績"
        }
    }
}
