//
//  UIAlertActionExtension.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/18.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import UIKit
import SafariServices

extension UIAlertAction {
    
    static func createPresentPlayerDetailAction(player: PlayerProtocol, navigationController: UINavigationController) -> UIAlertAction {
        return UIAlertAction(title: "選手詳細を表示する（外部サイト）", style: .default) { _ in
            let safariVC = SFSafariViewController(url: player.url)
            navigationController.present(safariVC, animated: true, completion: nil)
        }
    }
    
    static func createFavoriteAction(player: PlayerProtocol, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        
        let contains = FavoritePlayer.contains(player: player)
        
        return UIAlertAction(
            title: contains ? "お気に入りから削除する" : "お気に入りに登録する",
            style: contains ? .destructive : .default,
            handler: { alertAction in
                contains ? FavoritePlayer.delete(player) : FavoritePlayer.add(player)
                handler?(alertAction)
        })
    }
    
    static func createDraftedAction(player: PlayerProtocol, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        
        let contains = DraftedPlayer.contains(player: player)
        
        return UIAlertAction(
            title: contains ? "選択選手から削除する" : "選択選手に登録する",
            style: contains ? .destructive : .default,
            handler: { alertAction in
                contains ? DraftedPlayer.delete(player) : DraftedPlayer.add(player)
                handler?(alertAction)
        })
    }
    
    static func createCancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "キャンセル", style: .cancel, handler: handler)
    }
}
