//
//  StartViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 27..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutButton.layer.cornerRadius = 10
        orderButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwinddToStart(segue: UIStoryboardSegue) {
        
    }
    
}
