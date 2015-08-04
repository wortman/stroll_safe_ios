//
//  LockdownViewController.swift
//  Stroll Safe
//
//  Created by noah prince on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit
import CoreData

class LockdownViewController: UIViewController {
    
    class Lock {
        var pass: String = ""
        var locked: Bool = false
        
        /**
        Locks this lock with the given password
        
        :param: passwd the password
        */
        func lock(passwd: String) {
            pass = passwd
            locked = true
        }
        
        /**
        Attempts to unlock with the given password.
        
        :param: passwd The unlock password
        
        :returns: True if the pass unlocked it, false if it was an incorrect password
        */
        func unlock(passwd: NSString) -> Bool{
            locked = !(passwd == pass)
            return !locked
        }
        
        func isLocked() -> Bool{
            return locked
        }
    }
    
    let lock = Lock()

    @IBOutlet weak var progressCircle: CircleProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var first: UIButton!
    @IBOutlet weak var second: UIButton!
    @IBOutlet weak var third: UIButton!
    @IBOutlet weak var fourth: UIButton!
    @IBOutlet weak var placeholder1: UIView!
    @IBOutlet weak var placeholder2: UIView!
    @IBOutlet weak var placeholder3: UIView!
    @IBOutlet weak var placeholder4: UIView!
    @IBOutlet weak var progressLayer: UIView!
    

    var input = -1

    var currentIdx = 0;
    var timer = 0
    var velocity = 1
    let acceleration = 3
    var timerPressed: Bool = false
    let sleepTime:useconds_t = 10000
    
    weak var pinpadViewController: PinpadViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PinpadViewController
            where segue.identifier == "lockdownEmbedPinpad" {
                
                self.pinpadViewController = vc
        }
    }
    
/*  while (sizeof(array) < 4)
        listen for button presses
        chage input accordingly
        passField.append(input)
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            while (self.timer < 200) {
                usleep(self.sleepTime)
                dispatch_async(dispatch_get_main_queue(), {
                    self.timer+=self.velocity
                    let fractionalProgress = Double(self.timer)/200.0
                    
                    if (fractionalProgress <= 1){
                        self.progressCircle.progress = fractionalProgress
                        self.progressLabel.text = ("\(20-(self.timer/10))")
                    }
                })
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                    self.progressCircle.progress = 1
                    self.progressLabel.text = ("0")
            })
            
            if self.lock.isLocked() {
                let url:NSURL = NSURL(string: "tel://2179941016")!
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        setupPinpadViewWithStoredPasscode()
    }
    
    func setupPinpadViewWithStoredPasscode(managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!) {
        lock.lock(try! Passcode.get(managedObjectContext))

        pinpadViewController.setEnteredFunction({(pass: String) -> () in
            self.pinpadViewController.clear();
            if self.lock.unlock(pass) {
                self.performSegueWithIdentifier("unlockSegue", sender: nil)
            } else {
                self.pinpadViewController.shake();
            }
        })
    }
    
    @IBAction func timerTouchDown(sender: AnyObject) {
        timerPressed = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for _ in 0..<200 {
                if (self.timerPressed && self.lock.isLocked()){
                    self.velocity+=self.acceleration
                    usleep(self.sleepTime)
                }
                else{
                    break
                }
            }
        })
    }
    
    @IBAction func timerTouchUp(sender: AnyObject) {
        timerPressed = false
        velocity = 1
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
