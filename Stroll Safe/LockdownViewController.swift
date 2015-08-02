//
//  LockdownViewController.swift
//  Stroll Safe
//
//  Created by noah prince on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

class LockdownViewController: UIViewController {

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
            
            if OhShitLock.sharedInstance.isLocked() {
                let url:NSURL = NSURL(string: "tel://2179941016")!
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        setupPinpadView()
    }
    
    // Dependency injected lock
    //   see http://natashatherobot.com/unit-testing-swift-dependency-injection/
    func setupPinpadView(ohShitLock: OhShitLock = OhShitLock.sharedInstance) {
        pinpadViewController.setEnteredFunction({(pass: String) -> () in
            self.pinpadViewController.clear();
            if OhShitLock.sharedInstance.unlock(pass) {
                self.performSegueWithIdentifier("unlockSegue", sender: nil)
            }
            self.pinpadViewController.shake();
        })
    }
    
    @IBAction func timerTouchDown(sender: AnyObject) {
        timerPressed = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for _ in 0..<200 {
                if (self.timerPressed && OhShitLock.sharedInstance.isLocked()){
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
