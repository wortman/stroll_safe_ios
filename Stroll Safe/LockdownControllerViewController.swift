//
//  LockdownControllerViewController.swift
//  Stroll Safe
//
//  Created by christine prince on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

class LockdownControllerViewController: UIViewController {

    @IBOutlet weak var first: UIButton!
    @IBOutlet weak var second: UIButton!
    @IBOutlet weak var third: UIButton!
    @IBOutlet weak var fourth: UIButton!
    @IBOutlet weak var placeholder1: UIView!
    @IBOutlet weak var placeholder2: UIView!
    @IBOutlet weak var placeholder3: UIView!
    @IBOutlet weak var placeholder4: UIView!
    @IBOutlet weak var progressLayer: UIView!
    
    var correctPass = [Double](count: 4, repeatedValue: 2.0)
    var input = -1
    var passField = [Double](count: 4, repeatedValue: 0.0)
    var currentIdx = 0;
    
/*  while (sizeof(array) < 4)
        listen for button presses
        chage input accordingly
        passField.append(input)
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        clear()
        // Do any additional setup after loading the view.
    }
    
    func clear(){
        first.hidden = true
        second.hidden = true
        third.hidden = true
        fourth.hidden = true
        currentIdx = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passFieldString() -> NSString{
        var passString = "\(Int(passField[0]))\(Int(passField[1]))\(Int(passField[2]))\(Int(passField[3]))"
        return passString
    }
    
    func setPassField(value: Double){
        passField[currentIdx] = value
        currentIdx++

        switch currentIdx{
        case 1:
            first.hidden = false
        case 2:
            second.hidden = false
        case 3:
            third.hidden = false
        case 4:
            fourth.hidden = false
            if OhShitLock.sharedInstance.unlock(passFieldString()){
                self.performSegueWithIdentifier("unlockSegue", sender: nil)
            }else{
                clear()
                
                var numbers = [placeholder1,placeholder2,placeholder3,placeholder4]
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    for filler in numbers {
                        dispatch_async(dispatch_get_main_queue(), {
                            var number = filler as UIView
                    
                            let animation = CABasicAnimation(keyPath: "position")
                            animation.duration = 0.07
                            animation.repeatCount = 4
                            animation.autoreverses = true
                            animation.fromValue = NSValue(CGPoint: CGPointMake(number.center.x - 10, number.center.y))
                            animation.toValue = NSValue(CGPoint: CGPointMake(number.center.x    + 10, number.center.y))
                            number.layer.addAnimation(animation, forKey: "position")
                        })
                    }
                })
            }
            
        case 5:
            currentIdx--
        default:
            println("Invalid")
        }
        
    }
    
    @IBAction func buttonOne(sender: UIButton) {
        setPassField(1)
    }

    @IBAction func buttonTwo(sender: UIButton) {
        setPassField(2)
    }

    @IBAction func buttonThree(sender: UIButton) {
        setPassField(3)
    }
    
    @IBAction func buttonFour(sender: UIButton) {
        setPassField(4)
    }
    
    @IBAction func buttonFive(sender: UIButton) {
        setPassField(5)
    }
    
    @IBAction func buttonSix(sender: UIButton) {
        setPassField(6)
    }
    
    @IBAction func buttonSeven(sender: UIButton) {
        setPassField(7)
    }
    
    @IBAction func buttonEight(sender: UIButton) {
        setPassField(8)
    }
    
    @IBAction func buttonNine(sender: UIButton) {
        setPassField(9)
    }
    
    @IBAction func buttonClear(sender: UIButton) {
        first.hidden = true
        second.hidden = true
        third.hidden = true
        fourth.hidden = true
        
        currentIdx = 0
    }
    
    @IBAction func buttonZero(sender: UIButton) {
        setPassField(0)
    }
    
    @IBAction func buttonBack(sender: AnyObject) {
        switch currentIdx{
        case 0:
            println("Invalid")
        case 1:
            first.hidden = true
        case 2:
            second.hidden = true
        case 3:
            third.hidden = true
        default:
            println("Invalid")
        }

        currentIdx--
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
