//
//  PlayerMonster.swift
//  Combat
//
//  Created by Tyler Arnold on 5/24/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

import Cocoa

class PlayerMonster: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    var players = [[String]]()
    var monsters = [[String]]()
    var senderType: String?
    var saveDelegate: SaveDelegate?
    
    override func viewDidLoad() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        if row == 0 {
            cell.textField?.stringValue = "New Record +"
            cell.identifier? = NSUserInterfaceItemIdentifier(rawValue: "newRecord")
            return cell
        }
        
        if senderType == "monster" {
            cell.textField?.stringValue = monsters[row - 1][1]
        }else {
            cell.textField?.stringValue = players[row - 1][1]
        }
        
        return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if senderType == "monster" {
            return monsters.count + 1
        } else {
            return players.count + 1
        }
    }
    
    func newRecordPopOver(sender: AnyObject) {
        let controller = NSViewController()
        controller.view = NSView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(400), height: CGFloat(400)))
        
        let detailVC = saveDelegate as! DetailViewController
        let parentVC = detailVC.parent! as! NSSplitViewController
        let sourceVC = parentVC.childViewControllers[0] as! SourceViewController
        
        let popover = SourceViewPopover(db: sourceVC.db!, table_id: sourceVC.campaign_id!, delegate: self)
        popover.contentViewController = controller
        popover.contentSize = controller.view.frame.size
        
        popover.behavior = .transient
        popover.animates = true
        
        popover.popoverLabel()
        popover.popoverText()
        popover.popoverSaveButton()
        
        popover.show(relativeTo: sender.frame, of: sender as! NSView, preferredEdge: NSRectEdge.maxX)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow == 0 {
            self.newRecordPopOver(sender: self.view)
        }
    }
    
    func saveDidFinish() {
        let detailVC = saveDelegate as! DetailViewController
        let parentVC = detailVC.parent as! NSSplitViewController
        let sourceVC = parentVC.childViewControllers[0] as! SourceViewController
        
        players = (sourceVC.db?.getHero(from: sourceVC.campaign_id!))!
        monsters = (sourceVC.db?.getMonster())!
        tableView.reloadData()
    }
}
