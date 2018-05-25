//
//  PlayerMonsterSegue.swift
//  Combat
//
//  Created by Tyler Arnold on 5/24/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

import Cocoa

class PlayerMonsterSegue: NSStoryboardSegue {

    override func perform() {
        let sourceViewController = self.sourceController as! DetailViewController
        let controller = self.destinationController as! NSViewController
        
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.animates = true
        popover.behavior = .transient
        
        if self.identifier!.rawValue == "monster"{
            popover.show(relativeTo: sourceViewController.monsterBtn.frame, of: sourceViewController.view, preferredEdge: NSRectEdge.maxY)
        }else if self.identifier!.rawValue == "player" {
            popover.show(relativeTo: sourceViewController.playerBtn.frame, of: sourceViewController.view, preferredEdge: NSRectEdge.maxY)
        }
    }
}
