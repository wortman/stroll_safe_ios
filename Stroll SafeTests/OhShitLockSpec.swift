//
//  OhShitLockSpec.swift
//  StrollSafe
//
//  Created by Noah Prince on 7/26/15.
//  Copyright © 2015 Stroll Safe. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Stroll_Safe
import CoreData

class StoredPassLockSpec: QuickSpec {
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)
        
        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    override func spec() {
        describe("The Stored Password Lock") {
            var storedPassLock: StoredPassLock!
            
            it ("throws an error when there is no stored passcode") {
                class NSManagedObjectContextMock: NSManagedObjectContext {
                    enum Error: ErrorType {
                        case someerror
                    }
                    
                    override func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
                        throw Error.someerror
                    }
                }
                
                var context = NSManagedObjectContextMock()
                expect(StoredPassLock(context)).to(raiseException())
            }
            
            describe ("lock/unlocking with stored passcode") {
                var pass = "1234"

                class NSManagedObjectContextMock: NSManagedObjectContext {
                    override func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
                        return [pass]
                    }
                }
                
                var context: NSManagedObjectContextMock!
                beforeEach {
                    context = NSManagedObjectContextMock()
                    try! storedPassLock = StoredPassLock(context)
                    storedPassLock.lock()
                }
                
                it ("unlocks when provided the right code") {
                    expect(storedPassLock.unlock(pass)).to(beTrue())
                }
                
                it ("does not unlock when provided the wrong code") {
                    expect(storedPassLock.unlock("2222")).to(beFalse())
                }
            }
        }
    }
}