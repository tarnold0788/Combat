//
//  SplitSegue.swift
//  Combat
//
//  Created by Tyler Arnold on 5/23/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//
//I wrote this code to segue between different detailviews but I might not need it.


import Cocoa

class SplitSegue: NSStoryboardSegue {
    override func perform() {
        let detailViewController = self.sourceController as! NSViewController
        let newDetailViewController = self.destinationController as! NSViewController
        let containerViewController = detailViewController.parent! as! NSSplitViewController
        containerViewController.insertChildViewController(newDetailViewController, at: 2)
        
        newDetailViewController.view.frame.size = detailViewController.view.frame.size
        let targertFrameSize =  newDetailViewController.view.frame.size
        
        detailViewController.view.wantsLayer = true
        newDetailViewController.view.wantsLayer = true
        
        containerViewController.transition(from: detailViewController, to: newDetailViewController, options: NSViewController.TransitionOptions.slideLeft, completionHandler: nil)
        
        detailViewController.view.animator().setFrameSize(targertFrameSize)
        newDetailViewController.view.animator().setFrameSize(targertFrameSize)
        
        let currentFrame = detailViewController.view.window?.frame
        let currentRect = NSRectToCGRect(currentFrame!)
        
        containerViewController.childViewControllers[1].view.window?.setFrame(currentRect, display: true, animate: true)
        
        containerViewController.removeChildViewController(at: 1)
    }
}
