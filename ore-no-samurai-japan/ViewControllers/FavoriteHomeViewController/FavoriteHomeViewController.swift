//
//  FavoriteHomeViewController.swift
//  
//
//  Created by 白井誠 on 2019/12/16.
//

import UIKit

class FavoriteHomeViewController: UITableViewController {
    
    var players = [FavoritePlayer]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        players = FavoritePlayer.selectAll()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "favaritePlayerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? {
            let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            return cell
            }()
        
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        cell.imageView?.sd_setImage(with: player.team.imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        
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
