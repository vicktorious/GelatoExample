//
//  ConfirmViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 28..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

class ConfirmViewController : UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var totalPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "gradientBackground")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let intPrice = floor(totalPrice)
        if  intPrice == totalPrice {
            totalPriceLabel.text = "TOTAL: " +  String(Int(intPrice)) + "$"
        } else {
            totalPriceLabel.text = "TOTAL: " +  String(totalPrice) + "$"
        }
    }
    
    @IBAction func shoppingConfirmed(sender: AnyObject) {
        print("$$$")
    }
}