//
//  GeneralFunctions.swift
//  Wipic_Plain
//
//  Created by John Dorry on 4/9/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Delegate used to notify friends table view when there was an update
protocol FriendUpdate{
    func UpdateTableView()
}

// Delegate used to notify when an http request has been completed for async updates
protocol HttpFinished{
    func HttpComplete(status:Bool)
}

class Globals
{
    static var currentUser: String?
    static var currentID:String = "1"
    static var friendCount:Int?
    static var requestCount:Int?
    static var userFriends = [String]()
    static var userRequests = [String]()
    static var profileImage = UIImage?()
    
    static var httpDelegate:HttpFinished?
    
    static let connectionsServer = HttpServer(serverType: ServerTypes.connections)
    static let mediaServer = HttpServer(serverType: ServerTypes.media)
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    // Called on load of main wipic view controller load
    static func loadUserData(){
        httpGetProfileImage()
        httpGetFriends()
        httpGetRequests()
    }
    
    static func httpGetFriends(){
        let paramStr = "tag=userfriends&username=\(Globals.currentUser!)"
        
        var returnData:NSData?
        
        connectionsServer.getReturnFromServer(paramStr, methodType: "GET"){
            (data:NSData?) in
            returnData = data
            
            do{
                // create json object on input
                let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                
                // Get the success and error status
                let successStr = json["success"] as? String
                let errorStr = json["error"] as? String
                
                if(successStr! == "1" && errorStr! == "0"){
                    
                    if var users = json["users"] as? [[String: AnyObject]] {
                        // Get the number of friends
                        let count = users[0].removeValueForKey("count")!
                        friendCount = Int("\(count)")
                        
                        if friendCount > 0 {
                            // Get the set of friends
                            var friends = users[0].removeValueForKey("UserFriend") as? [String: AnyObject]
                            var index:Int = 1
                            
                            // Loop through and store the set of friends
                            while (index <= self.friendCount){
                                let thisFriend = friends!.removeValueForKey(String(index))!
                                self.userFriends.append("\(thisFriend)")
                                
                                index = index + 1;
                            }
                            
                            // Sort the list of friends
                            self.userFriends.sortInPlace()
                        }
                        
                    }
                    
                }
                else if(successStr! == "0" && errorStr! == "1"){
                    //TODO: Report to user
                }
            }
            catch{
                //TODO: Catch error
            }
        }

    }
    
    static func httpGetRequests(){
        let paramStr = "tag=userrequests&username=\(Globals.currentUser!)"
        
        var returnData:NSData?
        
        connectionsServer.getReturnFromServer(paramStr, methodType: "GET"){
            (data:NSData?) in
            returnData = data
            
            do{
                // create json object on input
                let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                
                // Get the success and error status
                let successStr = json["success"] as? String
                let errorStr = json["error"] as? String
                
                if(successStr! == "1" && errorStr! == "0"){
                    
                    if var users = json["users"] as? [[String: AnyObject]] {
                        // Get the number of friends
                        let count = users[0].removeValueForKey("count")!
                        requestCount = Int("\(count)")
                        
                        if requestCount > 0{
                            // Get the set of friends
                            var friends = users[0].removeValueForKey("UserRequests") as? [String: AnyObject]
                            var index:Int = 1
                            
                            // Loop through and store the set of friends
                            while (index <= self.requestCount){
                                let thisFriend = friends!.removeValueForKey(String(index))!
                                self.userRequests.append("\(thisFriend)")
                                
                                index = index + 1;
                            }
                            
                            // Sort the list of friends
                            self.userRequests.sortInPlace()
                        }
                        
                    }
                    
                }
                else if(successStr! == "0" && errorStr! == "1"){
                    //TODO: Report to user
                }
            }
            catch{
                //TODO: Catch error
            }
        }

    }
    
    static func httpAcceptOrDenyRequest(acceptee:String, status:String){

        let paramStr = "tag=acceptdenyrequest&acceptee=\(acceptee)&accepter=\(Globals.currentUser!)&status=\(status)"
        
        var returnData:NSData?
        var flag: Bool = false
        
        connectionsServer.getReturnFromServer(paramStr, methodType: "GET"){
            (data:NSData?) in
            returnData = data
            
            do{
                // create json object on input
                let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                
                // Get the success and error status
                let successStr = json["success"] as? String
                let errorStr = json["error"] as? String
                
                if(successStr! == "1" && errorStr! == "0"){
                    flag = true
                }
                else {
                    flag = false
                }
            }
            catch{
                flag = false
            }
            
            dispatch_async(dispatch_get_main_queue()){
                if let delegate = self.httpDelegate {
                    delegate.HttpComplete(flag)
                }
            }
        }
    }
    
    static func httpGetProfileImage(){
        let paramStr = "tag=profilepicture&username=\(Globals.currentUser!)&userid=\(Globals.currentID)"
        
        var returnData:NSData?
        
        mediaServer.getReturnFromServer(paramStr, methodType: "GET"){
            (data:NSData?) in
            returnData = data
            
            do{
                // create json object on input
                let json = try NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers)
                
                // Get the success and error status
                let successStr = json["success"] as? String
                let errorStr = json["error"] as? String
                let imageURL = json["image"] as? String
                
                if(successStr! == "1" && errorStr! == "0" && imageURL! != ""){
                    if let url = NSURL(string: imageURL!) {
                        if let data = NSData(contentsOfURL: url) {
                            profileImage = UIImage(data: data)
                        }        
                    }
                }
                else {
                    profileImage = nil
                }
            }
            catch{
                profileImage = nil
            }
            
        }
    }
}