//
//  IceCreamMenuTableViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 27..
//  Copyright © 2016. developer. All rights reserved.
//

import UIKit

class IceCreamMenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var basketSizeButton: UIButton!
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var payArrowButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var stateNumberImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var flavoursTableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var quantityChooserView: UIStackView!
    @IBOutlet weak var iceCreamMenu: UILabel!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    var urlSession: NSURLSession!
    
    var flavours = [String]()
    var prices = [String : Double]()
    
    var selectedFlavour = ""
    var basket = [String : Int]() {
        didSet {
            if basket.count != 0 {
                basketSizeButton.setBackgroundImage(UIImage(named: "whiteCircle")!, forState: UIControlState.Normal)
                var sum: Int = 0
                for flavour in flavours {
                    if let scoops = basket[flavour] {
                        sum = sum + scoops
                    }
                }
                basketSizeButton.setTitle(String(sum), forState: UIControlState.Normal)
                basketSizeButton.hidden = false
            } else {
                basketSizeButton.hidden = true
            }
        }
    }
    
    var webMessages = [AnyObject]() {
        didSet {
            for message in webMessages {
                if let castedMessage = message as? [NSObject: AnyObject] {
                    flavours.append(castedMessage["flavour"] as! String)
                    prices.updateValue(castedMessage["price"] as! Double, forKey: castedMessage["flavour"] as! String)
                }
            }
        }
    }
    
    var fileMessages = NSDictionary() {
        didSet {
            for message in fileMessages["iceCreams"] as! [NSDictionary] {
                if let castedMessage = message as [NSObject: AnyObject]? {
                    flavours.append(castedMessage["flavour"] as! String)
                    prices.updateValue(castedMessage["price"] as! Double, forKey: castedMessage["flavour"] as! String)
                }
            }
        }
    }
    
    var isBaskerEmpty : Bool = true {
        didSet {
            basketSizeButton.hidden = isBaskerEmpty
        }
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "gradientBackground")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        basketSizeButton.hidden = true
        flavoursTableView.delegate = self
        flavoursTableView.dataSource = self
        
        //downloadFlavours()
        
        quantityChooserView.hidden = true
        
        stateNumberImage.image = UIImage(named: "1")
        stateLabel.text = "Please choose your ice cream!"
        
        loadFlavours()
    }
    
    
    // MARK: - Table view data source

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavours.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (flavoursTableView.frame.height / 5)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("IceCreamCell")! as! IceCreamCell
        cell.backgroundColor = UIColor.clearColor()
        cell.flavourLabel.text = flavours[indexPath.row]
    
        let price = prices[flavours[indexPath.row]]!
        let intPrice = floor(price)
        if  intPrice == price {
            cell.priceLabel.text = String(Int(intPrice)) + "$"
        } else {
            cell.priceLabel.text = String(price) + "$"
        }
        
        if let quantity = basket[flavours[indexPath.row]] {
            cell.quantity = quantity
        } else {
            cell.quantity = 0
        }
        cell.restoreCellColor()
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "basketSegue" {
            let controller = segue.destinationViewController as! BasketTableViewController
            controller.flavours = flavours
            controller.prices = prices
            controller.basket = basket
        }
    }
    
    @IBAction func unwindToIceCreamMenu(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! BasketTableViewController
        flavours = controller.flavours
        prices = controller.prices
        basket = controller.basket
        
        flavoursTableView.reloadData()
    }
    
    
    // MARK: - JSON methods
    
    func downloadFlavours() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let url = NSURL(string: "http://atleast.aut.bme.hu/ait-ios/messenger/messages")
        let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
            if let data = data {
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                print (responseString)
                do{
                    guard let messages = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [AnyObject] else {
                        return
                    }
                    self.webMessages = messages
                    self.flavoursTableView.reloadData()
                } catch {
                    print("Error parsing JSON")
                }
            }
        })
        dataTask.resume()
    }
    
    func loadFlavours() {
        let path = NSBundle.mainBundle().pathForResource("Gelato", ofType: "json")
        guard let data = NSData(contentsOfFile: path!) else {
            return
        }
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(responseString)
        do {
            guard let fileMessages = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary else {
                return
            }
            self.fileMessages = fileMessages
            self.flavoursTableView.reloadData()
        }catch {
            print("Error parsing JSON")
        }
    }
    
}

    // MARK: - TableCell related methods

extension IceCreamMenuTableViewController : IceCreamCellDelegate {
    func newFlavourAdded(flavour: String) {
        
        selectedFlavour = flavour
        
        basicButtonsEnable(false)
        iceCreamMenu.hidden = true
        quantityChooserView.hidden = false
        
        if let quantity = basket[flavour] {
            oneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            twoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            threeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            fourButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            switch quantity {
            case 1:
                oneButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            case 2:
                twoButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            case 3:
                threeButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            case 4:
                fourButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            default:
                break
            }
        }
        
        stateNumberImage.image = UIImage(named: "2")
        stateLabel.text = "How many scoops do you want?"
        
        flavoursTableView.userInteractionEnabled = false
        
    }
    
    @IBAction func oneButtonPushed(sender: AnyObject) {
        basket.updateValue(1, forKey: selectedFlavour)
        
        selectedFlavour = ""
        
        basicButtonsEnable(true)
        iceCreamMenu.hidden = false
        quantityChooserView.hidden = true
        
        oneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        stateNumberImage.image = UIImage(named: "1")
        stateLabel.text = "Please choose your ice cream!"
        
        flavoursTableView.userInteractionEnabled = true
        flavoursTableView.reloadData()
    }
    
    @IBAction func twoButtonPushed(sender: AnyObject) {
        basket.updateValue(2, forKey: selectedFlavour)
        
        selectedFlavour = ""
        
        basicButtonsEnable(true)
        iceCreamMenu.hidden = false
        quantityChooserView.hidden = true
        
        twoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        stateNumberImage.image = UIImage(named: "1")
        stateLabel.text = "Please choose your ice cream!"
        
        flavoursTableView.userInteractionEnabled = true
        flavoursTableView.reloadData()
    }
    
    @IBAction func threeButtonPushed(sender: AnyObject) {
        basket.updateValue(3, forKey: selectedFlavour)
        
        selectedFlavour = ""
        
        basicButtonsEnable(true)
        iceCreamMenu.hidden = false
        quantityChooserView.hidden = true
        
        threeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        stateNumberImage.image = UIImage(named: "1")
        stateLabel.text = "Please choose your ice cream!"
        
        flavoursTableView.userInteractionEnabled = true
        flavoursTableView.reloadData()
    }
    
    @IBAction func fourButtonPushed(sender: AnyObject) {
        basket.updateValue(4, forKey: selectedFlavour)
        
        selectedFlavour = ""
        
        basicButtonsEnable(true)
        iceCreamMenu.hidden = false
        quantityChooserView.hidden = true
        
        fourButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        stateNumberImage.image = UIImage(named: "1")
        stateLabel.text = "Please choose your ice cream!"
        
        flavoursTableView.userInteractionEnabled = true
        flavoursTableView.reloadData()
    }
    
    func basicButtonsEnable(enabled: Bool) {
        basketSizeButton.enabled = enabled
        basketButton.enabled = enabled
        payButton.enabled = enabled
        payArrowButton.enabled = enabled
        backButton.enabled = enabled
    }
    
}






