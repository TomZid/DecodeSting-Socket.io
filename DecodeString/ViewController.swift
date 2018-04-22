//
//  ViewController.swift
//  DecodeString
//
//  Created by tom on 2018/4/19.
//  Copyright © 2018年 TZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func click() {
        let string = "[帅气]"
        let resultString = string.decodeStringFromPolling()
        print("resultString is: \(resultString)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

