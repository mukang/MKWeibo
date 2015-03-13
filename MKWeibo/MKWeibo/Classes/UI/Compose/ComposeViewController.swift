//
//  ComposeViewController.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/13.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
 
}
