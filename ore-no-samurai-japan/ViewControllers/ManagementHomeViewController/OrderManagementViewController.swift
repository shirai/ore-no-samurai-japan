//
//  OrderManagementViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/18.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XLPagerTabStrip
import SDWebImage

class OrderManagementViewController: UITableViewController, IndicatorInfoProvider {
    
    enum Section: Int, CaseIterable {
        case order = 0, undefined
        var headerName: String {
            switch self {
            case .order:     return "打順"
            case .undefined: return "オーダー外"
            }
        }
        
    }
    
    var playerDic = [Section: [DraftedPlayer]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPlayers()
        tableView.reloadData()
    }
    
    private func fetchPlayers() {
        playerDic[.order] = DraftedPlayer.selectAll().filter({ $0.order != nil }).sorted(by: { $0.order! < $1.order! })
        playerDic[.undefined] = DraftedPlayer.selectAll().filter({ $0.order == nil })
    }
    
    private func players(section: Int) -> [DraftedPlayer] {
        let section = Section(rawValue: section)!
        return playerDic[section] ?? [DraftedPlayer]()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "打順")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players(section: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            return cell
            }()
        
        let player = players(section: indexPath.section)[indexPath.row]
        cell.textLabel?.text = {
            let prefix: String
            if let order = player.order {
                prefix = "\(order)番 "
            } else {
                prefix = ""
            }
            return prefix + player.name
        }()
        cell.detailTextLabel?.text = player.position.positionName()
        cell.imageView?.sd_setImage(with: player.team.imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let player = players(section: sourceIndexPath.section)[sourceIndexPath.row]
        
        // VCプロパティを更新
        playerDic[Section(rawValue: sourceIndexPath.section)!]?.remove(at: sourceIndexPath.row)
        playerDic[Section(rawValue: destinationIndexPath.section)!]?.insert(player, at: destinationIndexPath.row)
        
        for (i, player) in players(section: Section.order.rawValue).enumerated() {
            player.update(order: i + 1)
        }
        players(section: Section.undefined.rawValue).forEach({
            $0.update(order: nil)
        })
        
        fetchPlayers()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].headerName
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
