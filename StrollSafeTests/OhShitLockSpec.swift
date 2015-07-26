//
//  OhShitLockSpec.swift
//  StrollSafe
//
//  Created by Lynda Prince on 7/26/15.
//  Copyright © 2015 Stroll Safe. All rights reserved.
//

import Foundation
import Nimble
import Quick
import StrollSafe

class OhShitLockSpec: QuickSpec {
    override func spec() {
        describe("The Oh Shit Lock") {
            var ohShitLock: OhShitLock!
            beforeEach {
                ohShitLock = OhShitLock()
                expect(ohShitLock.lock("1234")).to(beTrue())
                expect(ohShitLock.isLocked()).to(beTrue());
            }
            
            it ("unlocks when provided the right code") {
                expect(ohShitLock.unlock("1234")).to(beTrue())
                expect(ohShitLock.isLocked()).to(beFalse());
            }
            it ("does not unlock when provided the wrong code") {
                expect(ohShitLock.unlock("2222")).to(beFalse())
                expect(ohShitLock.isLocked()).to(beTrue());
            }
        }
    }
}
