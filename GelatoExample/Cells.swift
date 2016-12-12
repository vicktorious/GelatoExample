//
//  Cells.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 28..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

protocol IceCreamCellDelegate : class {
    func newFlavourAdded(flavour: String)
}

protocol BasketCellDelegate : class {
    func flavourDeleted(flavour: String)
}

class IceCreamCell : UITableViewCell {
    
    @IBOutlet weak var flavourLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addFlavourButton: UIButton!
    
    var quantity : Int = 0 {
        didSet {
            if quantity == 0 {
                addFlavourButton.setBackgroundImage(UIImage(named: "plus")!, forState: UIControlState.Normal)
                addFlavourButton.setTitle("", forState: UIControlState.Normal)
            } else {
                addFlavourButton.setBackgroundImage(UIImage(named: "redsquare")!, forState: UIControlState.Normal)
                addFlavourButton.setTitle(String(quantity), forState: UIControlState.Normal)
            }
        }
    }
    
    weak var delegate: IceCreamCellDelegate?
    
    @IBAction func flavourSelected(sender: UIButton) {
        
        if quantity == 0 {
            addFlavourButton.setBackgroundImage(UIImage(named: "redplus")!, forState: UIControlState.Normal)
        } else {
            addFlavourButton.setBackgroundImage(UIImage(named: "redsquare")!, forState: UIControlState.Normal)
            addFlavourButton.setTitle(String(quantity), forState: UIControlState.Normal)
        }
        
        flavourLabel.textColor = UIColor.whiteColor()
        priceLabel.textColor = UIColor.whiteColor()
        
        flavourLabel.backgroundColor = UIColor.redColor()
        priceLabel.backgroundColor = UIColor.redColor()
        
        delegate?.newFlavourAdded(flavourLabel.text!)
    }
    
    func restoreCellColor() {
        flavourLabel.textColor = UIColor.blackColor()
        priceLabel.textColor = UIColor.blackColor()
        
        flavourLabel.backgroundColor = UIColor.lightGrayColor()
        priceLabel.backgroundColor = UIColor.darkGrayColor()
    }
    
}

class BasketCell : UITableViewCell {
    
    @IBOutlet weak var flavourLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: BasketCellDelegate?
    
    var flavour : String!
    
    @IBAction func flavourDeleted(sender: AnyObject) {
        delegate?.flavourDeleted(flavour)
    }
}
