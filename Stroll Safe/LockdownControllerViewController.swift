//
//  LockdownControllerViewController.swift
//  Stroll Safe
//
//  Created by christine prince on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

class LockdownControllerViewController: UIViewController {

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

        first.hidden = true
        second.hidden = true
        third.hidden = true
        fourth.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    
    func setPassField(value: Double){
        switch currentIdx{
        case 0:
            first.hidden = false
        case 1:
            second.hidden = false
        case 2:
            third.hidden = false
        case 3:
            fourth.hidden = false
        default:
            println("Invalid")
        }
        passField[currentIdx] = value
        currentIdx++
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
