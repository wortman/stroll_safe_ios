//
//  ViewController.swift
//  Stroll Safe
//
//  Created by Guest User on 3/21/15.
//  Copyright (c) 2015 Stroll Safe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var releaseButton: UIButton!
    @IBOutlet weak var thumbButton: UIButton!
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var titleSub: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progressBar.hidden = true
        releaseButton.hidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

