//
//  GelatoChooserTableViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 27..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

class BasketTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var basketTableView: UITableView!
    
    var flavours : [String]!
    var prices : [String : Double]!
    var basket : [String : Int]! {
        didSet {
            chosenFlavours.removeAll()
            let collection = basket.keys
            for key in collection {
                chosenFlavours.append(key)
            }
        }
    }
    
    var chosenFlavours = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "gradientBackground")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        basketTableView.delegate = self
        basketTableView.dataSource = self
    }
    
    // MARK: - TableViewController
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasketCell")! as! BasketCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let flavour = chosenFlavours[indexPath.row]
        let scoops = basket[flavour]
        cell.flavour = flavour
        cell.flavourLabel.text = String(scoops!) + " - " + flavour
        
        let price = (Double(scoops!) * prices[flavour]!)
        let intPrice = floor(price)
        if  intPrice == price {
            cell.priceLabel.text = String(Int(intPrice)) + "$"
        } else {
            cell.priceLabel.text = String(price) + "$"
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirmPurchase" {
            let controller = segue.destinationViewController as! ConfirmViewController
            var total = 0.0
            for flavour in chosenFlavours {
                total = total + (Double(basket[flavour]!) * prices[flavour]!)
            }
            controller.totalPrice = total
        }
    }
    
    @IBAction func unwindToBasket(segue: UIStoryboardSegue) {
        
    }
}

    // MARK: - TableCell related methods

extension BasketTableViewController : BasketCellDelegate {
    func flavourDeleted(flavour: String) {
        basket.removeValueForKey(flavour)
        basketTableView.reloadData()
    }
}
