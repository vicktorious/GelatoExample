//
//  ViewController.swift
//  GelatoExample
//
//  Created by developer on 2016. 09. 26..
//  Copyright © 2016. developer. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    
    var users = [String]()
    var passwords = [String : String]()
    
    var fileMessages = NSDictionary() {
        didSet {
            for message in fileMessages["users"] as! [NSDictionary] {
                if let castedMessage = message as [NSObject: AnyObject]? {
                    users.append(castedMessage["username"] as! String)
                    passwords.updateValue(castedMessage["password"] as! String, forKey: castedMessage["username"] as! String)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        loadUsers()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.5, animations: {
                    self.containerViewConstraint.constant = keyboardSize.height
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.containerViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation

    @IBAction func loginAction(sender: AnyObject) {
        dismissKeyboard()
        var title = "Error"
        var message = ""
        
        var actionOk = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
        
        if let userName = userNameTextField.text {
            if let password = passwordTexField.text {
                if users.contains(userName) {
                    if passwords[userName] == password {
                        title = "Welcome!"
                        message = "Have some Ice Cream!"
                        actionOk = UIAlertAction(title: "OK", style: .Default) { _ in self.performSegueWithIdentifier("loginSegue", sender: sender)
                        }
                    } else {
                        message = "Wrong password!"
                    }
                } else {
                    message = "Invalid User!"
                }
            }
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loadUsers() {
        let path = NSBundle.mainBundle().pathForResource("Users", ofType: "json")
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
        } catch {
            print("Error parsing JSON")
        }
    }
}
