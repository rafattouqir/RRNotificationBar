//
//  ViewController.swift
//  RRNotificationBar
//
//  Created by RAFAT TOUQIR RAFSUN on 2/6/17.
//  Copyright © 2017 RAFAT TOUQIR RAFSUN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .green
    }
    
    @IBAction func showNotification(_ sender: Any) {
        
        RRNotificationBar().show(title: "New vote", message: "Someone voted you",onTap:{
            print("tapped")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}

