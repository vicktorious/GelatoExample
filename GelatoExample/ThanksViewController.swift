//
//  ThanksViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 28..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

class ThanksViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "gradientBackground")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
}
