//
//  ViewController.swift
//  Combat
//
//  Created by Tyler Arnold on 5/17/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

//This is the view controller that is presented when you first start the application.

/*
 ########################################################################################################################################
 #   This is the initial View that is displayed when app is open.                                                                       #
 #   TA 05/17/2018: Completed and appears to run without issue.                                                                         #
 ########################################################################################################################################
 */

import Cocoa

class CampaignViewController: NSViewController, NSPopoverDelegate, NSTableViewDelegate, NSTableViewDataSource, SaveDelegate {
    var db = DbConnection()
    var campaigns = [[String]]()
    var cellIdentifier: String?
    
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        campaigns = db.getCampaigns()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier!.rawValue == "SaveCampaign"{
            let saveVc = segue.destinationController as! SaveCampaignVC
            saveVc.db = self.db
            saveVc.delegate = self
        }
        
        if segue.identifier!.rawValue == "Encounters" {
            let splitVc = segue.destinationController as! NSSplitViewController
            let sourceVc = splitVc.childViewControllers[0] as! SourceViewController
            sourceVc.sideButtons = db.getlocations(from: cellIdentifier!)
            sourceVc.db = db
            sourceVc.table_id = cellIdentifier!
            sourceVc.campaign_id = cellIdentifier!
            cellIdentifier = nil
        }
    }
    
    func saveDidFinish() {
        campaigns = db.getCampaigns()
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return campaigns.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil}
        cell.textField?.stringValue = campaigns[row][1]
        cell.textField?.alignment = .center
        cell.identifier = NSUserInterfaceItemIdentifier(rawValue: campaigns[row][0])
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        cellIdentifier = campaigns[tableView.selectedRow][0]
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "Encounters"), sender: self)
    }
}

