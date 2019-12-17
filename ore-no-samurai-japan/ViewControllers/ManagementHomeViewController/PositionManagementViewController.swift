//
//  PositionManagementViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/18.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XLPagerTabStrip
import SDWebImage

class PositionManagementViewController: UITableViewController, IndicatorInfoProvider {
    
    var playerDic = [Position: [DraftedPlayer]]()
    
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
        Position.allCases.forEach({ (position: Position) in
            playerDic[position] = DraftedPlayer.selectAll().filter({ $0.position == position })
        })
    }
    
    private func players(section: Int) -> [DraftedPlayer] {
        let position = Position(rawValue: section)!
        return playerDic[position] ?? [DraftedPlayer]()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ポジション")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Position.allCases.count
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
        cell.textLabel?.text = player.name
        cell.imageView?.sd_setImage(with: player.team.imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let player = players(section: sourceIndexPath.section)[sourceIndexPath.row]
        player.update(position: Position(rawValue: destinationIndexPath.section)!)
        fetchPlayers()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Position(rawValue: section)?.positionName()
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
