//
//  DetailViewController.swift
//  Combat
//
//  Created by Tyler Arnold on 5/22/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController, SaveDelegate{
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var monsterBtn: NSButton!
    @IBOutlet weak var playerBtn: NSButton!
    @IBOutlet weak var selectLabel: NSTextField! {
        didSet {
            selectLabel.setNeedsDisplay()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        monsterBtn.isHidden = true
        playerBtn.isHidden = true
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let senderType = sender as! NSButton
        let playerMonster = segue.destinationController as! PlayerMonster
        let splitVC = parent as! NSSplitViewController
        let sourceVC = splitVC.childViewControllers[0] as! SourceViewController
        
        if senderType.identifier?.rawValue == "monster" {
            let playerMonster = segue.destinationController as! PlayerMonster
            playerMonster.senderType = "monster"
            playerMonster.monsters = (sourceVC.db?.getMonster())!
        }else {
            playerMonster.senderType = "player"
            playerMonster.players = (sourceVC.db?.getHero(from: sourceVC.campaign_id!))!
        }
        
        playerMonster.saveDelegate = self
    }
    
    func saveDidFinish() {
        print("Saving Thing")
    }
}
