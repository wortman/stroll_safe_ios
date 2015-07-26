//
//  ViewController.swift
//  Stroll Safe
//
//  Created by Guest User on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit
import CoreData
import Foundation

// Lets the time display as 2.00 and not 2
extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

class ViewController: UIViewController {
    enum state {
        case START, THUMB, RELEASE,SHAKE
    }
    var mode = state.START;
    
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var titleSub: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var thumb: UIButton!
    @IBOutlet weak var shake: UIButton!
    @IBOutlet weak var shakeDesc: UILabel!
    @IBOutlet weak var thumbDesc: UILabel!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && mode == state.SHAKE {
            OhShitLock.sharedInstance.lock(self.passcode)
            self.performSegueWithIdentifier("lockdownSegue", sender: nil)
        }
    }

    @IBAction func shakeLongPress(sender: AnyObject) {
        if sender.state == UIGestureRecognizerState.Began
        {
            enterStartState()
        }
    }
    
    /* Sets an observer to change progress every time 
    * the timer is updated 
    */
    var timer:Float = 0 /*{
        didSet {
            let fractionalProgress = Float(timer) / 200.0
            let animated = timer != 0
            
            progressBar.setProgress(fractionalProgress, animated: animated)
            progressLabel.text = ("\(timer/100)")

        }
    }*/
    var passcode: String = ""
        
    @IBAction func thumbDown(sender: UIButton) {
        enterThumbState()
    }
    
   @IBAction func thumbUpInside(sender: UIButton) {
        enterReleaseState()
    }
    
    @IBAction func thumbUpOutside(sender: AnyObject, forEvent event: UIEvent) {
        
        let buttonView = sender as! UIView
        let mainView = self.view
        
            // get any touch on the buttonView
         if let touch = event.touchesForView(buttonView)!.first {
            let location = touch.locationInView(mainView)
                
            let frame = shake.frame
            let minX = CGRectGetMinX(frame)
            let maxX = CGRectGetMaxX(frame)
            let minY = CGRectGetMinY(frame)
            let maxY = CGRectGetMaxY(frame)
            if ((location.x < minX || location.x > maxX) ||
                (location.y < minY || location.y > maxY)){
                    enterReleaseState()
                }else{
                    enterShakeState()
                }
            }
    }
    

    @IBAction func releaseButtonAction(sender: AnyObject) {
    }
    
    @IBAction func thumbButtonAction(sender: AnyObject) {
    }
    
    func enterStartState(){
        setThumbVisibility(true)
        setProgressVisibility(false)
        setShakeVisibility(false, type: true)
        changeTitle("Stroll Safe", sub: "Keeping You Safe on Your Late Night Strolls")
        
        mode = state.START
    }
    
    func enterThumbState(){
        timer = 0
        setThumbVisibility(false)
        setProgressVisibility(false)
        setShakeVisibility(true, type: true)
        changeTitle("Release Mode", sub:"Release Thumb to Contact Police")
        
        shakeDesc.text = "Slide Thumb and Release to Enter Shake Mode"
        
        mode = state.THUMB
    }
    
    func enterReleaseState(){
        setThumbVisibility(true)
        setProgressVisibility(true)
        setShakeVisibility(false,type: true)
        changeTitle("Thumb Released", sub: "Press and Hold Button to Cancel")
        mode = state.RELEASE
        
        progressLabel.text = "0"
        self.timer = 0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for _ in 0..<20 {
                if (self.mode != state.RELEASE){
                    break
                }
                usleep(2500)
                dispatch_async(dispatch_get_main_queue(), {
                    self.timer++
                    let fractionalProgress = Float(self.timer) / 20.0
                    let animated = false;
                
                    self.progressBar.setProgress(fractionalProgress, animated: animated)
                    self.progressLabel.text = ("\(2-(self.timer/10)) seconds remaining")
                })
            }
            if (self.mode == state.RELEASE){
                dispatch_async(dispatch_get_main_queue(), {
                    OhShitLock.sharedInstance.lock(self.passcode)
                    self.performSegueWithIdentifier("lockdownSegue", sender: nil)
                })
            }
        })
    }
    
    func enterShakeState(){
        timer = 0
        setThumbVisibility(true)
        setProgressVisibility(false)
        setShakeVisibility(true, type: false)
        changeTitle("Shake Mode", sub: "Shake Phone to Contact Police")
        
        shakeDesc.text = "Press and Hold to Exit the App"
        
        mode = state.SHAKE
    }
    
    func changeTitle(title: NSString,  sub: NSString){
        titleMain.text = title as String
        titleSub.text = sub as String
    }
    
    func setProgressVisibility(visibility: Bool){
        progressBar.hidden = !visibility
        progressLabel.hidden = !visibility
    }
    
    func setThumbVisibility(visibility: Bool){
        thumb.hidden = !visibility
        thumbDesc.hidden = !visibility
    }
    
    // First parameter is whether it's visible
    // Second sets it as the shake button when true,
    // exit button when false
    func setShakeVisibility(visibility: Bool, type: Bool){
        shake.hidden = !visibility
        shakeDesc.hidden = !visibility
        
        // Setup the shake icon
        if type{
            if let image  = UIImage(named: "shake_icon.png") {
                shake.setImage(image, forState: .Normal)
            }
        }
        else{
            if let image  = UIImage(named: "close_icon.png") {
                    shake.setImage(image, forState: .Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enterStartState()
        
        // Retreive the managedObjectContext from AppDelegate
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "Passcode")
        do {
            let fetchedResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Passcode]
            
            // Store the pass in our global pass var, if it's there. Otherwise, segue to the setPass scene
            if (!fetchedResults.isEmpty && fetchedResults[0].passcode != "empty"){
                self.passcode = fetchedResults[0].passcode
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("firstTimeUserSegue", sender: nil)
                })
            }
        }
        catch {
            print("Error retreiving passcode \(error)")
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("firstTimeUserSegue", sender: nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

