//
//  ViewWithPinpadController.swift
//  Stroll Safe
//
//  Created by Noah prince on 3/25/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

@objc protocol ViewWithPinpadController {
    
    func passEntered(pass: String) -> Bool

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
