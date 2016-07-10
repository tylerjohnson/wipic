//
//  RegisterViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 3/31/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var rPasswordField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let g = Globals()
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
    
    
    @IBAction func httpRegister(sender: AnyObject? = nil) {
        let name = nameField.text!
        let email = emailField.text!
        let username = usernameField.text!
        let password = passwordField.text!
        let repeatPassword = rPasswordField.text!
        var firstName: String?
        var lastName: String?
        var returnData:NSData?
        
        //Process input
        let spaceCount = name.characters.filter{$0 == " "}.count
        //Ensure there is a space between first and last name
        if(spaceCount > 0){
            let fullNameArr = name.componentsSeparatedByString(" ")
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
            if(firstName!.isEmpty || lastName!.isEmpty ){
                //Report error
                messageLabel.text = "Provide first and last name"
                messageLabel.hidden = false
                return
            }
        }
        else{
            //report error
            messageLabel.text = "Provide first and last name"
            messageLabel.hidden = false
            return
        }
        
        //Ensure proper email
        if(!g.isValidEmail(email)){
            //report error
            messageLabel.text = "Invalid email"
            messageLabel.hidden = false
            return
        }
        
        //Check proper username
        if(username.characters.count < 5 ){
            //report username too short
            messageLabel.text = "Username must be at least 5 characters"
            messageLabel.hidden = false
            return
        }
        else if(username.containsString(" ")){
            //report error in format
            messageLabel.text = "Username cannot contain spaces"
            messageLabel.hidden = false
            return
        }
        
        //Ensure proper password
        if(password.characters.count < 5){
            //report password too short
            messageLabel.text = "Password must be at least 5 characters"
            messageLabel.hidden = false
            return
        }
        else if(password.containsString(" ")){
            // report improper format
            messageLabel.text = "Password cannot contain spaces"
            messageLabel.hidden = false
            return
        }
        
        //Ensure password texts match
        if(password != repeatPassword){
            //report password does not match
            messageLabel.text = "Passwords do not match"
            messageLabel.hidden = false
            return
        }
        messageLabel.hidden = true
        
        //Start the activity indicator
        activityIndicator.startAnimating()
        
        let paramStr = "tag=register&email=\(email)&firstName=\(firstName!)&lastName=\(lastName!)&username=\(username)&password=\(password)"
        
        server.getReturnFromServer(paramStr, methodType: "POST"){
            (data:NSData?) in
            returnData = data
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                let successStr = json["success"] as? String
                let errorStr = json["error"] as? String
                print(successStr!)
                print(errorStr!)
                
                if(successStr == "1" && errorStr == "0"){
                    dispatch_async(dispatch_get_main_queue()){
                        self.messageLabel.text = "Check email to validate then login"
                        self.messageLabel.hidden = false
                        self.nameField.text = ""
                        self.emailField.text = ""
                        self.usernameField.text = ""
                        self.passwordField.text = ""
                        self.rPasswordField.text = ""
                    };
                    
                }
                else if(successStr == "0" && errorStr == "2"){
                    // TODO: report to user
                    dispatch_async(dispatch_get_main_queue()){
                        let errorMsg = json["error_msg"] as? String
                        self.messageLabel.text = errorMsg
                        self.messageLabel.hidden = false
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.activityIndicator.stopAnimating()
                }
                
            }
            catch{
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        
        if sender == nameField{
            emailField.becomeFirstResponder()
        }
        else if sender == emailField{
            usernameField.becomeFirstResponder()
        }
        else if sender == usernameField{
            passwordField.becomeFirstResponder()
        }
        else if sender == passwordField{
            rPasswordField.becomeFirstResponder()
        }
        else{
            rPasswordField.resignFirstResponder()
            httpRegister()
        }
    }
    
    func textFieldDidEndEditing(sender: UITextField? = nil) {
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        rPasswordField.resignFirstResponder()
    }
    
}
