//
//  PlayerListFetcher.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/10.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Kanna

private let baseURLString = "https://baseball-data.com/"

struct PlayerListFetcher {
    
    // MARK: - enumerations
    
    enum FetchType {
        case player
        case stats(Stats)
        
        var urlPath: String {
            switch self {
            case .player: return "player/"
            case .stats:  return "stats/"
            }
        }
    }
    
    struct Params {
        let type: FetchType
        let team: Team?
        let league: League?
    }
    
    // MARK: - Public Functions
    
    static func fetchPlayerPersonalityList(_ params: Params) -> [PlayerPersonality] {
        
        let url = createURL(params.type, team: params.team, league: params.league)
        let doc = try! HTML(url: url, encoding: .utf8)
        
        let playerElements = doc.xpath("//*[@id='tbl']/tbody/tr")
        return playerElements.map({ PlayerPersonality(element: $0, team: params.team!) })
    }
    
    static func fetchPlayerHittingStatsList(_ params: Params) -> [PlayerHittingStats] {
        
        let url = createURL(params.type, team: params.team, league: params.league)
        let doc = try! HTML(url: url, encoding: .utf8)
        
        let playerElements = doc.xpath("//*[@id='tbl']/tbody/tr")
        if let team = params.team {
            return playerElements.map({ PlayerHittingStats(element: $0, team: team) })
        } else {
            return playerElements.map({ PlayerHittingStats(element: $0) })
        }
    }
    
    static func fetchPlayerPitchingStatsList(_ params: Params) -> [PlayerPitchingStats] {
        
        let url = createURL(params.type, team: params.team, league: params.league)
        let doc = try! HTML(url: url, encoding: .utf8)
        
        let playerElements = doc.xpath("//*[@id='tbl']/tbody/tr")
        if let team = params.team {
            return playerElements.map({ PlayerPitchingStats(element: $0, team: team) })
        } else {
            return playerElements.map({ PlayerPitchingStats(element: $0) })
        }
    }
    
    // MARK: Private Functions
    
    private static func createURL(_ type: FetchType, team: Team? = nil, league: League? = nil) -> URL {
        
        let urlPath: String = {
            switch type {
            case .player:
                return "\(team!.cd)/"
            case .stats(let stats):
                return stats.urlPath(team: team, league: league)
            }
        }()
        
        return URL(string: baseURLString + type.urlPath + urlPath)!
    }
}

// MARK: - Enum extensions
extension League {
    var cd: String {
        switch self {
        case .central: return "ce"
        case .pacific: return "pa"
        }
    }
}

extension Team {
    /// チームコード
    var cd: String {
        switch self {
        case .giants:    return "g"
        case .bayStars:  return "yb"
        case .tigers:    return "t"
        case .carp:      return "c"
        case .dragons:   return "d"
        case .swallows:  return "s"
        case .lions:     return "l"
        case .hawks:     return "h"
        case .eagles:    return "e"
        case .marines:   return "m"
        case .fighters:  return "f"
        case .buffaloes: return "bs"
        }
    }
}

extension Stats {
    func urlPath(team: Team? = nil, league: League? = nil) -> String {
        switch self {
        case .hitter(let hitterStatsType):
            let basePath = "hitter-\(team?.cd ?? league?.cd ?? "all")/"
            guard let type = hitterStatsType else { return basePath }
            // 打率は規定以上のみ
            let suffix = type == .avg ? "-3.html" : "-1.html"
            return basePath + type.rawValue + suffix
        case .pitcher(let pitcherStatsType):
            let basePath = "pitcher-\(team?.cd ?? league?.cd ?? "all")/"
            guard let type = pitcherStatsType else { return basePath }
            // 防御率は規定以上のみ
            let suffix = type == .era ? "-3.html" : "-1.html"
            return basePath + type.rawValue + suffix
        }
    }
}

// MARK: - Kanna
extension PlayerPersonality {
    init(element: XMLElement, team: Team) {
        self.no = element.xpath("td[1]").first!.text!
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.team = team
        self.position = PositionRegistration(rawValue: element.xpath("td[3]").first!.text!)!
        self.birthday = element.xpath("td[4]").first!.text!
        self.age = element.xpath("td[5]").first!.text!
        self.professionalYears = element.xpath("td[6]").first!.text!
        self.height = element.xpath("td[7]").first!.text!
        self.weight = element.xpath("td[8]").first!.text!
        self.bloodType = element.xpath("td[9]").first!.text!
        self.bt = element.xpath("td[10]").first!.text!
        self.prefectures = element.xpath("td[11]").first!.text!
        self.salary = element.xpath("td[12]").first!.text!
    }
}

extension PlayerHittingStats {
    /// 球団＞打撃成績用
    /// - Parameters:
    ///   - element: xml
    ///   - team: チーム
    init(element: XMLElement, team: Team) {
        self.no = element.xpath("td[1]").first!.text!
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.team = team
        self.avg = element.xpath("td[3]").first!.text!
        self.app = element.xpath("td[4]").first!.text!
        self.tpa = element.xpath("td[5]").first!.text!
        self.ab = element.xpath("td[6]").first!.text!
        self.h = element.xpath("td[7]").first!.text!
        self.hr = element.xpath("td[8]").first!.text!
        self.rbi = element.xpath("td[9]").first!.text!
        self.sb = element.xpath("td[10]").first!.text!
        self.bb = element.xpath("td[11]").first!.text!
        self.hbp = element.xpath("td[12]").first!.text!
        self.so = element.xpath("td[13]").first!.text!
        self.sh = element.xpath("td[14]").first!.text!
        self.gdp = element.xpath("td[15]").first!.text!
        self.obp = element.xpath("td[16]").first!.text!
        self.slg = element.xpath("td[17]").first!.text!
        self.ops = element.xpath("td[18]").first!.text!
        self.rc27 = element.xpath("td[19]").first!.text!
        self.xr27 = element.xpath("td[20]").first!.text!
    }
    /// ランキング＞打撃成績用
    /// - Parameters:
    ///   - element: xml
    init(element: XMLElement) {
        self.no = nil
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.team = Team(name: element.xpath("td[3]").first!.text!)
        self.avg = element.xpath("td[4]").first!.text!
        self.app = element.xpath("td[5]").first!.text!
        self.tpa = element.xpath("td[6]").first!.text!
        self.ab = element.xpath("td[7]").first!.text!
        self.h = element.xpath("td[8]").first!.text!
        self.hr = element.xpath("td[9]").first!.text!
        self.rbi = element.xpath("td[10]").first!.text!
        self.sb = element.xpath("td[11]").first!.text!
        self.bb = element.xpath("td[12]").first!.text!
        self.hbp = element.xpath("td[13]").first!.text!
        self.so = element.xpath("td[14]").first!.text!
        self.sh = element.xpath("td[15]").first!.text!
        self.gdp = element.xpath("td[16]").first!.text!
        self.obp = element.xpath("td[17]").first!.text!
        self.slg = element.xpath("td[18]").first!.text!
        self.ops = element.xpath("td[19]").first!.text!
        self.rc27 = element.xpath("td[20]").first!.text!
        self.xr27 = element.xpath("td[21]").first!.text!
    }
}

extension PlayerPitchingStats {
    /// 球団＞打撃成績用
    /// - Parameters:
    ///   - element: xml
    ///   - team: チーム
    init(element: XMLElement, team: Team) {
        self.no = element.xpath("td[1]").first!.text!
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.team = team
        self.era = element.xpath("td[3]").first!.text!
        self.app = element.xpath("td[4]").first!.text!
        self.w = element.xpath("td[5]").first!.text!
        self.l = element.xpath("td[6]").first!.text!
        self.sv = element.xpath("td[7]").first!.text!
        self.hld = element.xpath("td[8]").first!.text!
        self.wpct = element.xpath("td[9]").first!.text!
        self.bf = element.xpath("td[10]").first!.text!
        self.ip = element.xpath("td[11]").first!.text!
        self.h = element.xpath("td[12]").first!.text!
        self.hr = element.xpath("td[13]").first!.text!
        self.bb = element.xpath("td[14]").first!.text!
        self.hbp = element.xpath("td[15]").first!.text!
        self.so = element.xpath("td[16]").first!.text!
        self.r = element.xpath("td[17]").first!.text!
        self.er = element.xpath("td[18]").first!.text!
        self.whip = element.xpath("td[19]").first!.text!
        self.dips = element.xpath("td[20]").first!.text!
    }
    /// ランキング＞投手成績用
    /// - Parameters:
    ///   - element: xml
    init(element: XMLElement) {
        self.no = nil
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.team = Team(name: element.xpath("td[3]").first!.text!)
        self.era = element.xpath("td[4]").first!.text!
        self.app = element.xpath("td[5]").first!.text!
        self.w = element.xpath("td[6]").first!.text!
        self.l = element.xpath("td[7]").first!.text!
        self.sv = element.xpath("td[8]").first!.text!
        self.hld = element.xpath("td[9]").first!.text!
        self.wpct = element.xpath("td[10]").first!.text!
        self.bf = element.xpath("td[11]").first!.text!
        self.ip = element.xpath("td[12]").first!.text!
        self.h = element.xpath("td[13]").first!.text!
        self.hr = element.xpath("td[14]").first!.text!
        self.bb = element.xpath("td[15]").first!.text!
        self.hbp = element.xpath("td[16]").first!.text!
        self.so = element.xpath("td[17]").first!.text!
        self.r = element.xpath("td[18]").first!.text!
        self.er = element.xpath("td[19]").first!.text!
        self.whip = element.xpath("td[20]").first!.text!
        self.dips = element.xpath("td[21]").first!.text!
    }
}
