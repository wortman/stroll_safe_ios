//
//  SetPasscodeViewController.swift
//  Stroll Safe
//
//  Created by christine prince on 3/25/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit
import CoreData

class SetPasscodeViewController: UIViewController,ViewWithPinpadController {
    @IBOutlet weak var subLabel: UILabel!

    var firstPass = ""
    var firstEntered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passEntered(pass: String) -> Bool{
        if (firstEntered){
            // They entered the second password, verify it's the same as the first one they entered
            if firstPass == pass {
                // Set the password in memory
                let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("Passcode", inManagedObjectContext: managedObjectContext!) as! Passcode
                
                var error : NSError? = nil
                do {
                    try managedObjectContext!.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
                
                newItem.passcode = pass
                
                // Transition to the main screen
                self.performSegueWithIdentifier("setPassSuccessSegue", sender: nil)
                
                return true
            }else{
                // They fucked up, take them back to the beginning
                firstEntered = false
                firstPass = ""
                
                subLabel.text = "Enter a passcode"
                return false
            }
        }else{
            // They entered the first password. When this function comes around again
            // We'll verify the password
            firstEntered = true
            firstPass = pass
            
            subLabel.text = "Re-enter passcode"
            return true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
