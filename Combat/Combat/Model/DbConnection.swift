//
//  DbConnection.swift
//  Combat
//
//  Created by Tyler Arnold on 5/17/18.
//  Copyright © 2018 Tyler Arnold. All rights reserved.


/*
#################################################################################################################################################################
#   Currently the only tables that I have are for the "hero" or character and for the campaign that will display when starting the application. TA 05/18/2018   #
#################################################################################################################################################################
 */


import Foundation
import SQLite3

class DbConnection {
    var db: OpaquePointer?
    
    
    //The initilizer either creates the database if it does not exist or it opens the database and sets the DB connection
    init(){
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("dndcharacter.sqlite")
        if sqlite3_open(fileUrl.path, &db) == SQLITE_OK {
            print("database was opened")
            self.createTableIfDoesNotExist()
            
        }
    }
    
    //Creates the tables if they do not exist
    func createTableIfDoesNotExist(){
        let tableStrings = ["CREATE TABLE IF NOT EXISTS campaign (campaign_id INTEGER PRIMARY KEY AUTOINCREMENT, campaign_name TEXT)",
                      "CREATE TABLE IF NOT EXISTS hero (hero_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, level INTEGER, hp INTEGER, campaign_id)",
                      "CREATE TABLE IF NOT EXISTS location (location_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, campaign_id INTEGER)",
                      "CREATE TABLE IF NOT EXISTS encounter (encounter_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, location_id INTEGER)",
                      "CREATE TABLE IF NOT EXISTS monster (monster_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, hp INTEGER, ac INTEGER, notes TEXT, picture TEXT)",
                      "CREATE TABLE IF NOT EXISTS combatants (combatant_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, encounter_id, monster_id, hero_id)"
                      ]
        
        for tableString in tableStrings {
            var createTableStatement: OpaquePointer?
            
            if sqlite3_prepare(db, tableString, -1, &createTableStatement, nil) == SQLITE_OK {
                
                if sqlite3_step(createTableStatement) == SQLITE_DONE {
                    print("\(tableString) created")
                } else {
                    print("Failed to create or already exists: \(tableString)")
                }
            } else {
                print("Failed to prepare: \(tableString)")
            }
            
            sqlite3_finalize(createTableStatement)
        }
        
    }
    
    
    //This method creates the campaign for the table campaign
    func createCampaign(_ campaignName: String) {
        var createCampaignStatement: OpaquePointer?
        
        let campaignString = "INSERT INTO campaign (campaign_name) VALUES (\"\(campaignName)\")"
        
        if sqlite3_prepare(db, campaignString, -1, &createCampaignStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(createCampaignStatement) == SQLITE_DONE {
                print("Campaign Created")
            } else {
                print("Campaign was not created!")
            }
        } else {
            print("create Campaign statement failed to prepare")
        }
        
        sqlite3_finalize(createCampaignStatement)
    }
    
    //This method returns campaigns for table
    func getCampaigns() -> [[String]]{
        var campaigns = [[String]]()
        
        var queryStatment: OpaquePointer?
        let queryString = "SELECT * FROM campaign"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatment, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatment) == SQLITE_ROW {
                campaigns.append([String(sqlite3_column_int(queryStatment, 0)), String(cString: sqlite3_column_text(queryStatment, 1))])
            }
        }
        return campaigns
    }
    
    //This Method returns locations of encounters
    func getlocations(from campaign_id: String) -> [[String]] {
        var locations = [[String]]()
        
        var queryStatement: OpaquePointer?
        let queryString = "SELECT * FROM location WHERE campaign_id=\(campaign_id)"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                locations.append([String(sqlite3_column_int(queryStatement, 0)), String(cString: sqlite3_column_text(queryStatement, 1)), String(sqlite3_column_int(queryStatement, 2))])
            }
        } else {
            print("failed to prepare query for locations")
        }
        return locations
    }
    
    func insertLocation(_ locationName: String, db_id: String) {
        var createLocationStatement: OpaquePointer?
        let createLocationString = "INSERT INTO location (name, campaign_id) VALUES(\"\(locationName)\", \(db_id))"
        
        if sqlite3_prepare(db, createLocationString, -1, &createLocationStatement, nil) == SQLITE_OK {
            if sqlite3_step(createLocationStatement) == SQLITE_DONE {
                print("Inserted into location")
            } else {
                print("Location insert failed!")
            }
        } else {
            print("Location failed to prepare")
        }
        sqlite3_finalize(createLocationStatement)
    }
    
    func getEncounter(from location: String) -> [[String]] {
        var encounters = [[String]]()
        var queryStatement: OpaquePointer?
        let queryString = "SELECT * FROM encounter WHERE location_id=\(location)"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                encounters.append([String(sqlite3_column_int(queryStatement, 0)), String(cString: sqlite3_column_text(queryStatement, 1)), String(sqlite3_column_int(queryStatement, 2))])
            }
        }
        return encounters
    }
    
    func insertEncounter(_ encounterName: String, table_id: String) {
        var createEncounterStatement: OpaquePointer?
        let createEncounterString = "INSERT INTO encounter(name, location_id) VALUES(\"\(encounterName)\",\(table_id))"
        
        if sqlite3_prepare(db, createEncounterString, -1, &createEncounterStatement, nil) == SQLITE_OK {
            if sqlite3_step(createEncounterStatement) == SQLITE_DONE {
                print("Encounter created")
            }
        } else {
            print("Encounter failed to prepare")
        }
    }
    
    func getCombatant(from encounter: String) -> [[String]] {
        var combatants = [[String]]()
        var queryStatment: OpaquePointer?
        let queryString = "SELECT * FROM combatants WHERE encounter_Id=\(encounter)"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatment, nil) == SQLITE_OK {
            while sqlite3_step(queryStatment) == SQLITE_ROW {
                print(String(sqlite3_column_int(queryStatment, 3)))
                combatants.append([String(sqlite3_column_int(queryStatment, 0)), String(cString: sqlite3_column_text(queryStatment, 1)), String(sqlite3_column_int(queryStatment, 2))])
            }
        }
        return combatants
    }
    
    func getHero(from table_id: String) -> [[String]]{
        var heros = [[String]]()
        var queryStatement: OpaquePointer?
        let queryString = "SELECT * FROM hero WHERE campaign_id = \(table_id)"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                heros.append([String(sqlite3_column_int(queryStatement, 0)),String(cString: sqlite3_column_text(queryStatement, 1))])
            }
        }
        return heros
    }
    
    func getMonster() -> [[String]]{
        var monsters = [[String]]()
        var queryStatement: OpaquePointer?
        let queryString = "SELECT * FROM monster"
        
        if sqlite3_prepare(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                monsters.append([String(sqlite3_column_int(queryStatement, 0)),String(cString: sqlite3_column_text(queryStatement, 1))])
            }
        }
        return monsters
    }
    
    func insertHero(name: String, from table_id: String) {
        var createHeroStatement: OpaquePointer?
        let createHeroString = "INSERT INTO hero (name, campaign_id) VALUES (\"\(name)\",\(table_id))"
        
        if sqlite3_prepare(db, createHeroString, -1, &createHeroStatement, nil) == SQLITE_OK {
            if sqlite3_step(createHeroStatement) == SQLITE_DONE {
                print("Hero created")
            }
        }
    }
    
    func insertMonster(name: String, from table_id: String) {
        var createMonsterStatement: OpaquePointer?
        let createMonsterString = "INSERT INTO monster (name) VALUES (\"\(name)\")"
        
        if sqlite3_prepare(db, createMonsterString, -1, &createMonsterStatement, nil) == SQLITE_OK {
            if sqlite3_step(createMonsterStatement) == SQLITE_DONE {
                print("Monster created")
            } else {
                print("uhhh")
            }
        } else {
            print("error")
        }
        sqlite3_finalize(createMonsterStatement)
    }
}
