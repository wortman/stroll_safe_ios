//
//  ViewController.swift
//  Stroll Safe
//
//  Created by Guest User on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

// Lets the time display as 2.00 and not 2
extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
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
    
    
    @IBAction func thumbDown(sender: UIButton) {
        enterThumbState()
    }
    
   @IBAction func thumbUpInside(sender: UIButton) {
        enterReleaseState()
    }
    
    @IBAction func thumbUpOutside(sender: AnyObject, forEvent event: UIEvent) {
        
        let buttonView = sender as UIView
        let mainView = self.view
        
            // get any touch on the buttonView
            if let touch = event.touchesForView(buttonView)?.anyObject() as? UITouch {
                let location = touch.locationInView(mainView)
                if ((location.x < 139 || location.x > 239) ||
                    (location.y < 249.0 || location.y > 350.5)){
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
            for i in 0..<20 {
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
        })
        
        performSegueWithIdentifier("lockdown", sender: nil)

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
        titleMain.text = title
        titleSub.text = sub
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

