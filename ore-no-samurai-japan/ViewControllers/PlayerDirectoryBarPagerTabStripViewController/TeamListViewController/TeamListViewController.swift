//
//  TeamListViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井　誠 on 2019/12/09.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XLPagerTabStrip
import SDWebImage

class TeamListViewController: UITableViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "チーム一覧")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return League.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return League(section: section).name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Team.list(with: League(section: section)).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "teamCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? {
            let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            return cell
            }()
        
        let team = Team(indexPath: indexPath)
        
        cell.textLabel?.text = team.fullName
        cell.imageView?.sd_setImage(with: team.imageURL, completed: { (image, error, _, _) in
            // なんか知らんが、自分でreloadRowsしないと反映されない。（自動で反映されるものだったような気がしたんだけどな）
            tableView.reloadRows(at: [indexPath], with: .none)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TeamTopPagerTabStripViewController.instantiate()
        vc.team = Team(indexPath: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Enum extensions
private extension League {
    init(section: Int) {
        switch section {
        case 0: self = .central
        case 1: self = .pacific
        default: fatalError()
        }
    }
}

private extension Team {
    init(indexPath: IndexPath) {
        self = Team.list(with: League(section: indexPath.section))[indexPath.row]
    }
}
