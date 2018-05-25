//
//  SourceViewPopover.swift
//  Combat
//
//  Created by Tyler Arnold on 5/24/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.
//

import Cocoa

class SourceViewPopover: NSPopover {
    private let db: DbConnection
    private let table_id: String
    private var textField: NSTextField?
    let del: NSViewController
    
    init(db: DbConnection, table_id: String, delegate: NSViewController){
        self.db = db
        self.table_id = table_id
        self.del = delegate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func popoverLabel() {
        let label = NSTextField(frame: NSMakeRect(150, 250, 100, 40))
        label.stringValue = "Record Name"
        label.isEditable = false
        label.isBordered = false
        label.drawsBackground = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.contentViewController!.view.centerXAnchor)
        self.contentViewController?.view.addSubview(label)
    }
    
    func popoverText() {
        let text = NSTextField(frame: NSMakeRect(170, 189, 100, 22))
        text.placeholderString = "Name"
        text.centerXAnchor.constraint(equalTo: self.contentViewController!.view.centerXAnchor)
        self.contentViewController?.view.addSubview(text)
        text.sizeToFit()
        self.textField = text
    }
    
    private func getTextFromField() -> String? {
        if textField?.stringValue != "" {
            return textField?.stringValue
        }
        return nil
    }
    
    func popoverSaveButton() {
        let saveBtn = NSButton(frame: NSMakeRect(150, 150, 100, 30))
        saveBtn.bezelStyle = .roundRect
        saveBtn.title = "Save"
        self.contentViewController?.view.addSubview(saveBtn)
        saveBtn.target = self
        saveBtn.action = #selector(saveButtonPressed)
    }
    
    @objc func saveButtonPressed() {
        guard let name = getTextFromField() else { return }
        
        if let sourceVC = del as? SourceViewController {
            
            switch sourceVC.tableType {
            case .campaign:
                db.insertLocation(name, db_id: table_id)
            case .location:
                db.insertEncounter(name, table_id: table_id)
            case .encounter:
                print("Made it here")
            default:
                break
            }
            
        } else {
            
            if let playerMonster = del as? PlayerMonster {
                print("made it to playermonster savedidfinish")
                if playerMonster.senderType == "monster" {
                    db.insertMonster(name: name, from: table_id)
                } else {
                    db.insertHero(name: name, from: table_id)
                }
            }
        }
        
        if let saveDel = del as? SaveDelegate {
            saveDel.saveDidFinish()
        } else {
            print("made it to playermonster savedidfinish")
            let playerMonster = del as! PlayerMonster
            playerMonster.saveDidFinish()
        }
        self.performClose(self)
    }
}
