//
//  Passcode.swift
//  Stroll Safe
//
//  Created by Noah Prince on 3/25/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import Foundation
import CoreData

public class Passcode: NSManagedObject {
    enum PasscodeError: ErrorType {
        case NoResultsFound
    }

    @NSManaged var passcode: String

    /**
    Gets the stored passcode for the given managed object context
    
    :param: moc the managed object context
    */
    func get(moc: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: "Passcode")
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as? [Passcode]
            if let result = fetchResults!.first {
                return result.passcode
            } else {
                throw StoredPassLockError.NoResultsFound
            }
        } catch let fetchError as NSError {
            print("fetch Passcode error: \(fetchError.localizedDescription)")
            throw fetchError
        }
    }
    
}
