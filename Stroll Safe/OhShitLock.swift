//
//  OhShitLock.swift
//  Stroll Safe
//
//  Created by christine prince on 3/22/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import Foundation
private let _OhShitLockSharedInstance = OhShitLock()

class OhShitLock {
    var pass: String = ""
    var locked: Bool = false
    
    class var sharedInstance: OhShitLock{
        return _OhShitLockSharedInstance
    }
    
    // Locks the lock, returns true if locked
    func lock(passwd: NSString) -> Bool{
        pass = passwd as String
        locked = true
        return locked
    }
    
    /* Attempts to unlock with the given password.
    *  Inputs -- passwd -- The unlock password
    *  Returns -- True if the pass unlocked it, false if it was an incorrect password
    */
    func unlock(passwd: NSString) -> Bool{
        locked = !(passwd == pass)
        return !locked
    }
    
    func isLocked() -> Bool{
        return locked
    }
}
