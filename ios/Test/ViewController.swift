//
//  ViewController.swift
//  Test
//
//  Created by Fahid Attique on 01/04/2024.
//  Copyright © 2024 Max Lynch. All rights reserved.
//

import UIKit
import Plugin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        CarPlayHelper.shared.startStreaming()
    }


}

