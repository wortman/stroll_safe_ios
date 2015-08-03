//
//  OhShitLockSpec.swift
//  StrollSafe
//
//  Created by Noah Prince on 7/26/15.
//  Copyright © 2015 Stroll Safe. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Stroll_Safe
import CoreData

class StoredPassLockSpec: QuickSpec {
    
    override func spec() {
        describe("The Stored Password Lock") {
            var storedPassLock: StoredPassLock!
            var moc: NSManagedObjectContext!
            
            beforeEach  {
                moc = TestUtils().setUpInMemoryManagedObjectContext()
            }
            
            // Commented out while Nimble is still shitty and doesn't work
            it ("throws an error when there is no stored passcode") {
                expect{ try StoredPassLock(moc: moc) }.to(throwError())
            }
            
            describe ("lock/unlocking with stored passcode") {
                let pass = "1234"
                
                beforeEach {
                    StoredPassLock.setPass(pass, moc: moc)
                    storedPassLock = try! StoredPassLock(moc: moc)
                    storedPassLock.lock()
                }
                
                it ("unlocks when provided the right code") {
                    expect(storedPassLock.unlock(pass)).to(beTrue())
                    expect(storedPassLock.isLocked()).to(beFalse())
                }
                
                it ("does not unlock when provided the wrong code") {
                    expect(storedPassLock.unlock("2222")).to(beFalse())
                    expect(storedPassLock.isLocked()).to(beTrue())
                }
            }
        }
    }
}