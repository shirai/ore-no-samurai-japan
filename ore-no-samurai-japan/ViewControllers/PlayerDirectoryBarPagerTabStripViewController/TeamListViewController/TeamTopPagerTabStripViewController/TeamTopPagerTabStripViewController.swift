//
//  PlayerListViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/09.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import Foundation

import UIKit
import XLPagerTabStrip

class TeamTopPagerTabStripViewController: ButtonBarPagerTabStripViewController, StoryboardInstantiatable {
    
    var team: Team!
    
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
        
        title = team.fullName
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [
            PlayerListViewController(type: .player, team: team),
            PlayerListViewController(type: .stats(Stats.pitcher(nil)), team: team),
            PlayerListViewController(type: .stats(Stats.hitter(nil)), team: team)
        ]
    }
}
