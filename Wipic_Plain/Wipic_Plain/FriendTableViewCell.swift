//
//  FriendTableViewCell.swift
//  Wipic_Plain
//
//  Created by John Dorry on 4/27/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell, HttpFinished {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    var ButtonPressed:Int = -1 // 0: Check was pressed; 1: X was pressed
    
    var delegate:FriendUpdate?
    
    func setThumbnailImage(thumbnailImage: UIImage){
        self.friendImage.image = thumbnailImage
    }
    
    func getThumbnailImage() -> UIImage{
        return self.friendImage.image!
    }
    
    func setFriendLabelText(friendName: String){
        self.friendLabel.text = friendName
    }
    
    func getFriendLabelText()-> String{
        return self.friendLabel.text!
    }
    // On button down the httpDelegate is set to this view
    @IBAction func ButtonTouchDown(sender: AnyObject) {
        Globals.httpDelegate = self
    }
    
    @IBAction func CheckPressed(sender: AnyObject) {
        ButtonPressed = 0
        Globals.httpAcceptOrDenyRequest(getFriendLabelText(), status:"1")
    }
    
    @IBAction func XPressed(sender: AnyObject) {
        ButtonPressed = 1
        Globals.httpAcceptOrDenyRequest(getFriendLabelText(), status:"0")
    }
    
    // Function called when HTTP request is complete and data is to be updated
    func HttpComplete(status: Bool) {
        if(status){
            if(ButtonPressed == 0){
                Globals.userFriends.append(getFriendLabelText())
                let index = Globals.userRequests.indexOf(getFriendLabelText())
                Globals.userRequests.removeAtIndex(index!)
                Globals.friendCount! += 1
                Globals.requestCount! -= 1
                Globals.userFriends.sortInPlace()
            }
            else if(ButtonPressed == 1){
                let index = Globals.userRequests.indexOf(getFriendLabelText())
                Globals.userRequests.removeAtIndex(index!)
                Globals.requestCount! -= 1
            }
            if let delegate = self.delegate {
                delegate.UpdateTableView()
            }
            ButtonPressed = -1
        }
        else{
            //TODO: Report error
        }
    }
}
