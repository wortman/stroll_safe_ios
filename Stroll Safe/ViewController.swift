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
    

    @IBAction func shakeUp(sender: AnyObject) {
        enterShakeState();
    }

    /* Sets an observer to change progress every time 
    * the timer is updated 
    */
    var timer:Float = 0 {
        didSet {
            let fractionalProgress = Float(timer) / 200.0
            let animated = timer != 0
            
            progressBar.setProgress(fractionalProgress, animated: animated)
            progressLabel.text = ("\(timer/100)")

        }
    }
    
    
    @IBAction func thumbDown(sender: UIButton) {
        enterThumbState();
    }
    
   @IBAction func thumbUpInside(sender: UIButton) {
        enterReleaseState()
    }
    
    @IBAction func thumbUpOutside(sender: AnyObject) {
        var touch = touches.anyObject()
        var point = touch.locationInView(self.view)
        println(point);
        enterReleaseState()
    }
    
    @IBAction func releaseButtonAction(sender: AnyObject) {
    }
    
    @IBAction func thumbButtonAction(sender: AnyObject) {
    }
    
    func enterStartState(){
        progressBar.hidden = true
        progressLabel.hidden = true
        thumb.hidden = false
        shake.hidden = true
        mode = state.START
    }
    
    func enterThumbState(){
        timer = 0
        thumb.hidden = true;
        progressBar.hidden = true
        progressLabel.hidden = true
        shake.hidden = false
        
        titleMain.text = "Release Mode"
        titleSub.text = "Release Thumb to Contact Police"
        
        
        mode = state.THUMB
    }
    
    func enterReleaseState(){
        thumb.hidden = false
        progressBar.hidden = false
        progressLabel.hidden = false
        shake.hidden = true
        mode = state.RELEASE
        
        progressLabel.text = "0%"
        self.timer = 0
        for i in 0..<200 {
            if (mode != state.RELEASE){
                break;
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                usleep(1000000)
                dispatch_async(dispatch_get_main_queue(), {
                    self.timer++
                    return
                })
            })
        }
    }
    
    func enterShakeState(){
        timer = 0
        thumb.hidden = false
        progressBar.hidden = true
        progressLabel.hidden = true
        
        titleMain.text = "Shake Mode"
        titleSub.text = "Shake Phone to Contact Police"
        
        
        mode = state.SHAKE
    }
    
    func update(){
        timer -= 0.1
        
        let fractionalProgress = 1-(Float(timer) / 2)
        let animated = timer != 2
        
        progressBar.setProgress(fractionalProgress, animated: animated)
        
        let doubleFormat = "1.2"
        var time = "\(timer.format(doubleFormat))"
        progressLabel.text = (time)
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

