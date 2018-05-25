//
//  SaveCampaignVC.swift
//  Combat
//
//  Created by Tyler Arnold on 5/17/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

/*
 ########################################################################################################################################
 #   This is the popover that is used when creating a new campaign                                                                      #
 #   TA 05/17/2018: Appears that this works without issue.                                                                              #
 ########################################################################################################################################
 */

import Cocoa

class SaveCampaignVC: NSViewController {
    var delegate: SaveDelegate?
    
    @IBOutlet weak var campaignTextField: NSTextField!
    var db: DbConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.layer?.backgroundColor = NSColor.systemBlue.cgColor
    }
    
    @IBAction func saveBtnPressed(_ sender: NSButton) {
        db?.createCampaign(campaignTextField.stringValue)
        delegate?.saveDidFinish()
        self.dismiss(sender)
    }
    
    @IBAction func cancelBtnPressed(_ sender: NSButton) {
        self.dismiss(sender)
    }
    
}
