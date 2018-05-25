//
//  SourceViewController.swift
//  Combat
//
//  Created by Tyler Arnold on 5/22/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//


import Cocoa

class SourceViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, SaveDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    var sideButtons = [[String]]()
    var tableType: TableType = .campaign
    var db: DbConnection?
    var table_id: String?
    var campaign_id: String?
    
    //Function that updates the sidebar after a selction has been mades
    func loadSideBar() {
        switch tableType{
        case .campaign:
            sideButtons = (db?.getlocations(from: table_id!))!
        case .location:
            sideButtons = (db?.getEncounter(from: table_id!))!
        case .encounter:
            sideButtons = (db?.getCombatant(from: table_id!))!
        default:
            print("Oops!")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //Function to find how many cells will be in the view
    func numberOfRows(in tableView: NSTableView) -> Int {
        if sideButtons.isEmpty {
            return 1
        }
        return sideButtons.count + 1
    }
    
    //This is what populates the cells in the table view
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        if row == 0 {
            cell.textField?.stringValue = "New Record +"
            cell.identifier? = NSUserInterfaceItemIdentifier(rawValue: "newRecord")
            return cell
        }
        
        cell.textField?.stringValue = sideButtons[row - 1][1]
        
        return cell
    }
    
    //This handles changing the detail view and updating the side bar when table cell is selected
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else {return}
        guard let splitVC = parent as? NSSplitViewController else {return}
        guard let detailVC = splitVC.childViewControllers[1] as? DetailViewController else {return}
        
        if tableView.selectedRow != 0{
            detailVC.selectLabel.stringValue = "\(sideButtons[tableView.selectedRow - 1][1])"
            
            switch tableType {
            case .campaign:
                tableType = .location
                table_id = sideButtons[tableView.selectedRow - 1][0]
                print(tableType)
            case .location:
                tableType = .encounter
                table_id = sideButtons[tableView.selectedRow - 1][0]
                detailVC.monsterBtn.isHidden = false
                detailVC.playerBtn.isHidden = false
                detailVC.monsterBtn.isEnabled = true
                detailVC.playerBtn.isEnabled = true
                detailVC.startBtn.isEnabled = true
            case .encounter:
                tableType = .combatants
                table_id = sideButtons[tableView.selectedRow - 1][0]
            default:
                detailVC.selectLabel.stringValue = "Test"
            }
            loadSideBar()
        } else {
            self.newRecordPopOver(sender: self.view)
        }
    }
    
    //This function builds the popover that I need to diskplay only when the first cell is selected.
    func newRecordPopOver(sender: AnyObject) {
        let controller = NSViewController()
        controller.view = NSView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(400), height: CGFloat(400)))
        
        let popover = SourceViewPopover(db: db!, table_id: table_id!, delegate: self)
        popover.contentViewController = controller
        popover.contentSize = controller.view.frame.size
        
        popover.behavior = .transient
        popover.animates = true
        
        popover.popoverLabel()
        popover.popoverText()
        popover.popoverSaveButton()
        
        popover.show(relativeTo: sender.bounds, of: sender as! NSView, preferredEdge: NSRectEdge.maxX)
    }
    
    //Function that the view uses to conform to saveDelegates
    func saveDidFinish() {
        loadSideBar()
    }
}
