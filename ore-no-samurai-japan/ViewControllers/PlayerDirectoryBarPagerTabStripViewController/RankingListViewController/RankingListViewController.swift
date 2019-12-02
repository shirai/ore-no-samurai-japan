//
//  RankingListViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/09.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XLPagerTabStrip
import SDWebImage

class RankingListViewController: UITableViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "成績一覧")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return League.allCases.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "両リーグ"
        case 1: return League.central.name
        case 2: return League.pacific.name
        default: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "statsCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? {
            let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            return cell
            }()
        
        cell.textLabel?.text = {
            switch indexPath.row {
            case 0: return Stats.hitter(nil).name
            case 1: return Stats.pitcher(nil).name
            default: fatalError()
            }
        }()
        let imageURL: URL = {
            switch indexPath.section {
            case 0: return URL(string: "http://p.npb.jp/img/common/logo/logo_npb_header.gif")!
            case 1: return League.central.imageURL
            case 2: return League.pacific.imageURL
            default: fatalError()
            }
        }()
        cell.imageView?.sd_setImage(with: imageURL, completed: { (image, error, _, _) in
            // なんか知らんが、自分でreloadRowsしないと反映されない。（自動で反映されるものだったような気がしたんだけどな）
            tableView.reloadRows(at: [indexPath], with: .none)
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RankingTopPagerTabStripViewController.instantiate()
        vc.league = {
            switch indexPath.section {
            case 0: return nil
            case 1: return .central
            case 2: return .pacific
            default: fatalError()
            }
        }()
        vc.stats = {
            switch indexPath.row {
            case 0: return .hitter(nil)
            case 1: return .pitcher(nil)
            default: fatalError()
            }
        }()
        navigationController?.pushViewController(vc, animated: true)
    }
}
