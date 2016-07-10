//
//  ServerFunctions.swift
//  Wipic_Plain
//
//  Created by John Dorry on 4/9/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import Foundation

enum ServerTypes {
    case account
    case connections
    case media
}
class HttpServer
{
    var thisType:ServerTypes = ServerTypes.account
    
    init(){
        thisType = ServerTypes.account
    }
    init(serverType:ServerTypes){
        thisType = serverType
    }
    
    func getReturnFromServer(paramString: String, methodType: String, completion: ((data:NSData?)->Void)){
        
        var myURL: NSURL?
        if(methodType == "GET"){
            myURL = NSURL(string: "http://wi-pic.us/\(getServerString(thisType)!)?\(paramString)")
        }
        else{
            myURL = NSURL(string: "http://wi-pic.us/\(getServerString(thisType)!)/")
        }
        
        let request = NSMutableURLRequest(URL: myURL!)
        
        request.HTTPMethod = methodType
        if(methodType == "POST"){
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding);
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in completion(data: data)
            
            if(error != nil){
                print("error = \(error)")
            }
        }
        task.resume()
    }
    
    func getServerString(type:ServerTypes) -> String?{
        var serverTypeStr:String?
        if(type == ServerTypes.account){
            serverTypeStr = "account"
        }
        else if(type == ServerTypes.connections){
            serverTypeStr = "connections"
        }
        else if(type == ServerTypes.media){
            serverTypeStr = "media"
        }
        return serverTypeStr
    }
}