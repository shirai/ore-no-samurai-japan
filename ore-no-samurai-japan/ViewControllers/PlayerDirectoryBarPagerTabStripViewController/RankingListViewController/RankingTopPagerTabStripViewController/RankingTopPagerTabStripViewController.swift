//
//  RankingTopPagerTabStripViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/15.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

import UIKit
import XLPagerTabStrip

class RankingTopPagerTabStripViewController: ButtonBarPagerTabStripViewController, StoryboardInstantiatable {
    
    /// リーグ(nilは両リーグ)
    var league: League?
    var stats: Stats!
    
    override func viewDidLoad() {
        settings.style.buttonBarMinimumLineSpacing = 10
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = settings.style.buttonBarBackgroundColor
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(red: 254/255, green: 0, blue: 124/255, alpha: 1)
        super.viewDidLoad()
        
        title = (league?.name ?? "両リーグ") + stats.name
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        switch stats {
        case .hitter:
            return [
                PlayerListViewController(type: .stats(Stats.hitter(.avg)), league: league),
                PlayerListViewController(type: .stats(Stats.hitter(.hr)), league: league),
                PlayerListViewController(type: .stats(Stats.hitter(.rbi)), league: league),
                PlayerListViewController(type: .stats(Stats.hitter(.sb)), league: league)
            ]
        case .pitcher:
            return [
                PlayerListViewController(type: .stats(Stats.pitcher(.era)), league: league),
                PlayerListViewController(type: .stats(Stats.pitcher(.win)), league: league),
                PlayerListViewController(type: .stats(Stats.pitcher(.so)), league: league),
                PlayerListViewController(type: .stats(Stats.pitcher(.save)), league: league)
            ]
        case .none: fatalError()
        }
    }
}
