//
//  FriendsTableViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 4/27/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController, FriendUpdate{
    
    let reuseFriendIdentifier = "FriendCell"
    let reuseRequestIdentifier = "RequestCell"
    let server = HttpServer(serverType: ServerTypes.connections)
    var userFriends = [String]()
    var userRequests = [String]()
    var friendCount:Int?
    var requestCount:Int?
    
    var friendsExist:Bool = false
    var requestsExist:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        friendCount = 0
        self.userFriends = Globals.userFriends
        self.userRequests = Globals.userRequests
        self.friendCount = Globals.friendCount
        self.requestCount = Globals.requestCount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        var count:Int = 0
        
        if(friendCount > 0){
            count += 1
            friendsExist = true
        }
        if(requestCount > 0){
            count += 1
            requestsExist = true
        }
        return count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int)->String{
        if(section == 0){
            if(friendsExist){
                return "Friends"
            }
            else {
                return "Friend Requests"
            }
        }
        else {
            return "Friend Requests"
        }
    }
    
    //Return number of cells
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(section == 0){
            if(friendsExist){
                return Int(friendCount!)
            }
            else {
                return Int(requestCount!)
            }
        }
        else {
            return Int(requestCount!)
        }
        
    }
    
    //Return specific cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let section = indexPath.section
        
        let cell:FriendTableViewCell?// = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! FriendTableViewCell
        
        if(section == 0){
            cell = (tableView.dequeueReusableCellWithIdentifier(self.reuseFriendIdentifier, forIndexPath: indexPath) as! FriendTableViewCell)
        }
        else{
            cell = (tableView.dequeueReusableCellWithIdentifier(self.reuseRequestIdentifier, forIndexPath: indexPath) as! FriendTableViewCell)
        }
        
        // Configure the cell
        if(section == 0){
            if(friendsExist){
                cell!.setFriendLabelText(self.userFriends[indexPath.row])
            }
            else{
                cell!.setFriendLabelText(self.userRequests[indexPath.row])
            }
            
        }
        else{
            cell!.setFriendLabelText(self.userRequests[indexPath.row])
        }
        cell?.delegate = self
        return cell!

    }
    
    // Called from delegate to notify a change in user data
    func UpdateTableView() {
        reloadData()
    }
    
    func reloadData(){
        self.userFriends = Globals.userFriends
        self.userRequests = Globals.userRequests
        self.friendCount = Globals.friendCount
        self.requestCount = Globals.requestCount
        self.tableView.reloadData()
    }
}
