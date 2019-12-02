//
//  PlayerObject.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/16.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation
import RealmSwift

class PlayerObject: Object, PlayerProtocol {
    
    /// 選手名
    @objc dynamic var name = ""
    
    /// 選手詳細URL
    var url: URL { return URL(string: urlString)! }
    @objc dynamic private var urlString = ""
    
    /// チーム
    var team: Team { return Team(name: _teamName) }
    @objc dynamic private var _teamName = ""
    
    convenience init(player: PlayerProtocol) {
        self.init()
        self.name = player.name
        self.urlString = player.url.absoluteString
        self._teamName = player.team.name
    }
    
    static func delete(_ player: PlayerProtocol) {
        let realm = try! Realm()
        try! realm.write {
            let favoritePlayer = realm.objects(self).filter("name == \"\(player.name)\"")
            realm.delete(favoritePlayer)
        }
    }
    
    static func contains(player: PlayerProtocol) -> Bool {
        return try! Realm().objects(self).filter("name == \"\(player.name)\"").count > 0
    }
}

/// お気に入り選手
class FavoritePlayer: PlayerObject {
    
    static func selectAll() -> [FavoritePlayer] {
        return try! Realm().objects(self).map({ FavoritePlayer(value: $0) })
    }
    
    static func add(_ player: PlayerProtocol) {
        let realm = try! Realm()
        try! realm.write {
            let favoritePlayer = FavoritePlayer(player: player)
            realm.add(favoritePlayer)
        }
    }
}

/// 選択選手
class DraftedPlayer: PlayerObject {
    
    /// 守備位置/投手起用方法
    var position: Position {
        return Position(rawValue: _position)!
    }
    @objc dynamic private var _position = Position.undefined.rawValue
    
    /// 打順
    var order: Int? { return _order.value }
    private let _order = RealmOptional<Int>()
    
    static func selectAll() -> [DraftedPlayer] {
        return try! Realm().objects(self).map({ DraftedPlayer(value: $0) })
    }
    
    static func add(_ player: PlayerProtocol) {
        let realm = try! Realm()
        try! realm.write {
            let draftedPlayer = DraftedPlayer(player: player)
            realm.add(draftedPlayer)
        }
    }
    
    func update(position: Position) {
        let realm = try! Realm()
        try! realm.write {
            let player = realm.objects(DraftedPlayer.self).filter("name == \"\(name)\"").first
            player?._position = position.rawValue
        }
    }
    
    func update(order: Int?) {
        let realm = try! Realm()
        try! realm.write {
            let player = realm.objects(DraftedPlayer.self).filter("name == \"\(name)\"").first
            player?._order.value = order
        }
    }
}
