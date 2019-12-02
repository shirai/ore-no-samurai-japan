//
//  Team.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/10.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

private let short_name_g  = "巨人"
private let short_name_db = "DeNA"
private let short_name_t  = "阪神"
private let short_name_c  = "広島"
private let short_name_d  = "中日"
private let short_name_s  = "ヤクルト"
private let short_name_l  = "西武"
private let short_name_h  = "ソフトバンク"
private let short_name_e  = "楽天"
private let short_name_m  = "ロッテ"
private let short_name_f  = "日本ハム"
private let short_name_b  = "オリックス"

enum Team: CaseIterable {
    
    case giants
    case bayStars
    case tigers
    case carp
    case dragons
    case swallows
    case lions
    case hawks
    case eagles
    case marines
    case fighters
    case buffaloes
    
    /// チーム名（一般略称）
    var name: String {
        switch self {
        case .giants:    return short_name_g
        case .bayStars:  return short_name_db
        case .tigers:    return short_name_t
        case .carp:      return short_name_c
        case .dragons:   return short_name_d
        case .swallows:  return short_name_s
        case .lions:     return short_name_l
        case .hawks:     return short_name_h
        case .eagles:    return short_name_e
        case .marines:   return short_name_m
        case .fighters:  return short_name_f
        case .buffaloes: return short_name_b
        }
    }
    /// チーム名（正式名称）
    var fullName: String {
        switch self {
        case .giants:    return "読売ジャイアンツ"
        case .bayStars:  return "横浜DeNAベイスターズ"
        case .tigers:    return "阪神タイガース"
        case .carp:      return "広島東洋カープ"
        case .dragons:   return "中日ドラゴンズ"
        case .swallows:  return "東京ヤクルトスワローズ"
        case .lions:     return "埼玉西武ライオンズ"
        case .hawks:     return "福岡ソフトバンクホークス"
        case .eagles:    return "東北楽天ゴールデンイーグルス"
        case .marines:   return "千葉ロッテマリーンズ"
        case .fighters:  return "北海道日本ハムファイターズ"
        case .buffaloes: return "オリックス・バファローズ"
        }
    }
    /// リーグ
    var league: League {
        switch self {
        case .giants, .bayStars, .tigers, .carp, .dragons, .swallows:
            return .central
        case .lions, .hawks, .eagles, .marines, .fighters, .buffaloes:
            return .pacific
        }
    }
    
    var imageURL: URL {
        switch self {
        case .giants:    return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_g_l.gif")!
        case .bayStars:  return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_db_l.gif")!
        case .tigers:    return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_t_l.gif")!
        case .carp:      return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_c_l.gif")!
        case .dragons:   return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_d_l.gif")!
        case .swallows:  return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_s_l.gif")!
        case .lions:     return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_l_l.gif")!
        case .hawks:     return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_h_l.gif")!
        case .eagles:    return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_e_l.gif")!
        case .marines:   return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_m_l.gif")!
        case .fighters:  return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_f_l.gif")!
        case .buffaloes: return URL(string: "http://p.npb.jp/img/common/logo/2019/logo_b_l.gif")!
        }
    }
    
    init(name: String) {
        switch name {
        case short_name_g : self = .giants
        case short_name_db: self = .bayStars
        case short_name_t : self = .tigers
        case short_name_c : self = .carp
        case short_name_d : self = .dragons
        case short_name_s : self = .swallows
        case short_name_l : self = .lions
        case short_name_h : self = .hawks
        case short_name_e : self = .eagles
        case short_name_m : self = .marines
        case short_name_f : self = .fighters
        case short_name_b : self = .buffaloes
        default: fatalError()
        }
    }
    
    static func list(with league: League) -> [Team] {
        return allCases.filter({ $0.league == league })
    }
}
