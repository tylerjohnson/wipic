//
//  LoginViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 3/31/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let server = HttpServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func httpLogin(sender: AnyObject? = nil) {
        let username = usernameField.text!
        let password = passwordField.text!
        var returnData:NSData?
        if(username != "" && password != "" && !username.containsString(" ") && !password.containsString(" ")){
            
            activityIndicator.startAnimating()
            
            let paramStr = "tag=login&username=\(username)&password=\(password)"
            
            server.getReturnFromServer(paramStr, methodType: "GET"){
                (data:NSData?) in
                returnData = data
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                    let successStr = json["success"] as? String
                    let errorStr = json["error"] as? String

                    
                    if(successStr! == "1" && errorStr! == "0"){
                        Globals.currentUser = username
                        Globals.loadUserData()
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.hidden = true
                            let tabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NavView") as! UINavigationController
                            self.presentViewController(tabViewController, animated: true, completion: nil)
                        };
                        
                    }
                    else if(successStr! == "0" && errorStr! == "1"){
                        // TODO: report to user
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.hidden = false
                            self.messageLabel.text = "Incorrect username or password."
                        }
                        
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.activityIndicator.stopAnimating()
                    }
                    
                }
                catch{
                    
                }
            }
            
        }

    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        if(sender == usernameField){
            passwordField.becomeFirstResponder()
        }
        else{
            passwordField.resignFirstResponder()
            httpLogin(nil)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField? = nil) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    


}
