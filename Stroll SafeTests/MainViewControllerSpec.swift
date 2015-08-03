//
//  PinpadViewControllSpec.swift
//  Stroll Safe
//
//  Created by Noah Prince on 7/31/15.
//  Copyright © 2015 Stroll Safe. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData
@testable import Stroll_Safe

class MainViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe ("the main view") {
            class StoredPassLockMock: Stroll_Safe.StoredPassLock {
                var lockCalled: Bool!
                
                override func lock() {
                    lockCalled = true
                }
                
                override func isLocked() -> Bool {
                    return true
                }
            }
            
            var viewController: Stroll_Safe.MainViewController!
            var lock: StoredPassLockMock!
            let moc = TestUtils().setUpInMemoryManagedObjectContext()
            StoredPassLockMock.setPass("1234", moc: moc)
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController =
                    storyboard.instantiateViewControllerWithIdentifier(
                        "MainView") as! Stroll_Safe.MainViewController

                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()

                lock = try! StoredPassLockMock(moc: moc)
                
                viewController.injectDeps(lock)
            }
            
            it ("starts out in the default state") {
                expect(viewController.thumb.hidden).to(beFalse())
                expect(viewController.thumbDesc.hidden).to(beFalse())
                expect(viewController.shake.hidden).to(beTrue())
                expect(viewController.shakeDesc.hidden).to(beTrue())
                expect(viewController.progressLabel.hidden).to(beTrue())
                expect(viewController.progressBar.hidden).to(beTrue())
            }
            
            it ("exposes the enable shake interface when the thumb is pressed") {
                viewController.thumbDown(UIButton())
            
                expect(viewController.thumb.hidden).to(beTrue())
                expect(viewController.thumbDesc.hidden).to(beTrue())
                expect(viewController.shake.hidden).to(beFalse())
                expect(viewController.shakeDesc.hidden).to(beFalse())
                expect(viewController.progressLabel.hidden).to(beTrue())
                expect(viewController.progressBar.hidden).to(beTrue())
            }
            
            it ("exposes the progress bar and thumb interface when thumb is released and eventually locks down") {
                viewController.thumbUpInside(UIButton())
                
                
                expect(viewController.thumb.hidden).to(beFalse())
                expect(viewController.thumbDesc.hidden).to(beFalse())
                expect(viewController.shake.hidden).to(beTrue())
                expect(viewController.shakeDesc.hidden).to(beTrue())
                expect(viewController.progressLabel.hidden).to(beFalse())
                expect(viewController.progressBar.hidden).to(beFalse())
                
                expect(lock.lockCalled).toEventually(beTrue(), timeout: 2)
            }
            
            it ("does not lock down immediately when thumb is released") {
                viewController.thumbUpInside(UIButton())
                
                expect(lock.lockCalled).to(beNil())
            }
        }
    }
}