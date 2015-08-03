//
//  OhShitLock.swift
//  Stroll Safe
//
//  Created by christine prince on 3/22/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StoredPassLock {
    var pass: String = ""
    var locked: Bool = false
    var moc: NSManagedObjectContext!
    static var _StoredPassLockSharedInstance: StoredPassLock?
    
    enum StoredPassLockError: ErrorType {
        case NoResultsFound
    }
    
    class func sharedInstance() throws -> StoredPassLock {
        if let instance = _StoredPassLockSharedInstance {
            return instance
        } else {
            _StoredPassLockSharedInstance = try StoredPassLock()
            return _StoredPassLockSharedInstance!
        }
    }
    
    init(moc: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!) throws {
        self.moc = moc
        
        let fetchRequest = NSFetchRequest(entityName: "Passcode")
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Passcode]
            if let result = fetchResults!.first {
                self.pass = result.passcode
            } else {
                throw StoredPassLockError.NoResultsFound
            }
        } catch let fetchError as NSError {
            print("fetch Passcode error: \(fetchError.localizedDescription)")
            throw fetchError
        }
    }
    
    /**
    Sets and stores the given password.
    
    :param: passwd The password
    */
    class func setPass(passwd: String, moc: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!) {
        // Store the password
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Passcode", inManagedObjectContext: moc) as! Passcode
        do {
            try moc.save()
        } catch let error as NSError {
            NSLog("Unresolved error while storing password \(error), \(error.userInfo)")
            abort()
        }
        
        newItem.passcode = passwd
    }

    /**
    Puts the StoredPassLock into 'locked' mode, only to be unlocked
    by a correct password
    */
    func lock() {
        locked = true
    }
    
    /**
    Attempts to unlock this instance with the provided password.
    
    :param: passwd The password to unlock with
    
    :returns: true if the unlock was successful. False otherwise
    */
    func unlock(passwd: String) -> Bool{
        locked = !(passwd == pass)
        return !locked
    }
    
    /**
    Returns whether this instance is in the locked state
    
    :returns: the locked state
    */
    func isLocked() -> Bool{
        return locked
    }
}
