//
//  CrossfadeStoryboardSegue.swift
//  Combat
//
//  Created by Tyler Arnold on 5/18/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

/*
 #################################################################################################################################################################
 #   This is the segue that allows me to alter the child view of the window so that it will display multiple views in the same window.                           #
 #   TA 05/21/2018: Completed Transition.                                                                                                                        #
 #################################################################################################################################################################
 */

import Cocoa

class CrossfadeStoryboardSegue: NSStoryboardSegue {
    override func perform() {
        //These commands establish the view controllers that we are comin from and going to as well as the containing view
        let sourceViewController = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewcontroller = sourceViewController.parent!
        containerViewcontroller.insertChildViewController(destinationViewController, at: 1)
        
        //This is the size of the view we are changing to
        destinationViewController.view.frame.size = containerViewcontroller.view.frame.size
        let targetSize = destinationViewController.view.frame.size
        
        //These lines are necessary to show the animation. Not necessary if you dont use animation
        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true
        
        //This is the method that changes which views are being displayed
        containerViewcontroller.transition(from: sourceViewController, to: destinationViewController, options: NSViewController.TransitionOptions.crossfade, completionHandler: nil)
        
        //These establish the frame size of views
        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)
        
        //These methods create variables for the frame size and then adjust the size of the window
        let currentFrame = containerViewcontroller.view.window?.frame
        let currentRect = NSRectToCGRect(currentFrame!)
        
        containerViewcontroller.view.window?.setFrame(currentRect, display: true, animate: true)
        
        //This removes the previous child frame.
        containerViewcontroller.removeChildViewController(at: 0)

        
    }
}
