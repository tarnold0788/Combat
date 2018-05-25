//
//  ContainerViewController.swift
//  Combat
//
//  Created by Tyler Arnold on 5/18/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

/*
 #################################################################################################################################################################
 #   This is the parent view controller that contains the subviews that will be displayed.                                                                       #
 #   05/18/2018: Completed and Appears to run without Issue.
 #################################################################################################################################################################
 */

import Cocoa

class ContainerViewController: NSViewController, NSWindowDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let campaignStoryboard = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "campaign")) as! NSViewController
        
        campaignStoryboard.view.translatesAutoresizingMaskIntoConstraints = false
        self.insertChildViewController(campaignStoryboard, at: 0)
        
        self.view.addSubview(campaignStoryboard.view)
        self.setConstraints()
        self.view.frame = campaignStoryboard.view.frame
    }
    
    //Updated removeChildViewController to reste the size of the view that is added when it preforms the segue
    override func removeChildViewController(at index: Int) {
        super.removeChildViewController(at: index)
        self.childViewControllers[0].view.translatesAutoresizingMaskIntoConstraints = false
        self.setConstraints()
    }
    
    //This sets the constraints so that when a subview is added it will anchor it to the window view.
    func setConstraints() {
        
        let subViewConstraints = [
            self.childViewControllers[0].view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.childViewControllers[0].view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.childViewControllers[0].view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.childViewControllers[0].view.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(subViewConstraints)
    }
}
