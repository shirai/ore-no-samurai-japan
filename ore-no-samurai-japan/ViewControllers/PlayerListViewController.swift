//
//  PlayerListViewController.swift
//  ore-no-samurai-japan
//
//  Created by 白井誠 on 2019/12/14.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XLPagerTabStrip
import SDWebImage

class PlayerListViewController: UITableViewController, IndicatorInfoProvider {
    
    let type: PlayerListFetcher.FetchType
    let team: Team?
    let league: League?
    
    var playerPersonalityList = [PlayerPersonality]()
    var playerPitchingStatsList = [PlayerPitchingStats]()
    var playerHittingStatsList = [PlayerHittingStats]()
    
    init(type: PlayerListFetcher.FetchType, team: Team? = nil, league: League? = nil) {
        self.type = type
        self.team = team
        self.league = league
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: インジケータでも出すかね？
        switch type {
        case .player:
            playerPersonalityList = PlayerListFetcher.fetchPlayerPersonalityList(PlayerListFetcher.Params(type: type, team: team, league: league))
        case .stats(let statsType):
            switch statsType {
            case .hitter:
                playerHittingStatsList = PlayerListFetcher.fetchPlayerHittingStatsList(PlayerListFetcher.Params(type: type, team: team, league: league))
            case .pitcher:
                playerPitchingStatsList = PlayerListFetcher.fetchPlayerPitchingStatsList(PlayerListFetcher.Params(type: type, team: team, league: league))
            }
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let title: String = {
            switch type {
            case .player: return "選手一覧"
            case .stats(let type):
                switch type {
                case .hitter(let hitterStatsType):
                    return hitterStatsType?.name ?? type.name
                case .pitcher(let pitcherStatsType):
                    return pitcherStatsType?.name ?? type.name
                }
            }
        }()
        return IndicatorInfo(title: title)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .player:
            return PositionRegistration.allCases.count
        case .stats:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch type {
        case .player:
            return PositionRegistration.allCases.map({ $0.rawValue })[section]
        case .stats:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .player:
            let position = PositionRegistration.allCases[section]
            return playerPersonalityList.filter({ $0.position == position }).count
        case .stats(let statsType):
            switch statsType {
            case .hitter:
                return playerHittingStatsList.count
            case .pitcher:
                return playerPitchingStatsList.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "playerCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            return cell
            }()
        
        switch type {
        case .player:
            let position = PositionRegistration.allCases[indexPath.section]
            let player = playerPersonalityList.filter({ $0.position == position })[indexPath.row]
            
            cell.textLabel?.text = "#\(player.no) \(player.name)"
            cell.detailTextLabel?.text = player.description
        case .stats(let statsType):
            switch statsType {
            case .hitter:
                let player = playerHittingStatsList[indexPath.row]
                let prefix = player.no == nil ? "" : "#\(player.no!) "
                cell.textLabel?.text = prefix + player.name
                cell.detailTextLabel?.text = player.description
                if team == nil {
                    cell.imageView?.sd_setImage(with: player.team.imageURL)
                }
            case .pitcher:
                let player = playerPitchingStatsList[indexPath.row]
                let prefix = player.no == nil ? "" : "#\(player.no!) "
                cell.textLabel?.text = prefix + player.name
                cell.detailTextLabel?.text = player.description
                if team == nil {
                    cell.imageView?.sd_setImage(with: player.team.imageURL)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let player: PlayerProtocol = {
            switch type {
            case .player:
                let position = PositionRegistration.allCases[indexPath.section]
                return playerPersonalityList.filter({ $0.position == position })[indexPath.row]
            case .stats(let statsType):
                switch statsType {
                case .hitter:  return playerHittingStatsList[indexPath.row]
                case .pitcher: return playerPitchingStatsList[indexPath.row]
                }
            }
        }()
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)?.contentView
        
        let deselectRowHandler = { (alertAction: UIAlertAction) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        actionSheet.addAction(
            .createFavoriteAction(player: player, handler: deselectRowHandler))
        actionSheet.addAction(
            .createDraftedAction(player: player, handler: deselectRowHandler))
        actionSheet.addAction(
            .createPresentPlayerDetailAction(player: player,
                                             navigationController: navigationController!))
        actionSheet.addAction(
            .createCancelAction(handler: deselectRowHandler))
        
        navigationController?.present(actionSheet, animated: true, completion: nil)
    }
}
