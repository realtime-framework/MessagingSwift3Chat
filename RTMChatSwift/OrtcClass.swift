//
//  OrtcClass.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 15/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit
import RealtimeMessaging_iOS_Swift3
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class OrtcClass: NSObject, OrtcClientDelegate{
    let APPKEY = "<INSERT_YOUR_APPKEY>"
    let TOKEN = "TOKEN"
    let METADATA = "METADATA"
    let URL = "http://ortc-developers.realtime.co/server/2.1/"
    
    var ortc: OrtcClient?
    var onMessage:AnyObject?
    
    var channels:NSMutableArray?
    var channelsIndex:NSMutableDictionary?
    
    func connect()
    {
        self.ortc = OrtcClient.ortcClientWithConfig(self)
        self.ortc!.connectionMetadata = METADATA as NSString?
        self.ortc!.clusterUrl = URL as NSString?
        
        self.ortc!.connect(APPKEY as NSString?, authenticationToken: TOKEN as NSString?)
        channels = NSMutableArray()
        channelsIndex = NSMutableDictionary()
        loadChannels()
    }
    
    
    func subscribeChannel(_ channel:String)
    {
        self.ortc!.subscribeWithNotifications(channel, subscribeOnReconnected: true, onMessage: { (ortcClient:OrtcClient!, channel:String!, message:String!) -> Void in
            self.processMessage(channel, message: message)
        })

    }
    
    func processMessage(_ channel:String!, message:String!){
        let messageArray = message.components(separatedBy: ":")
        
        var jsonMessage:[String: AnyObject] = [String: AnyObject]()
        
        jsonMessage["NickName"] = messageArray[0] as AnyObject?
        jsonMessage["Message"] = messageArray[1] as AnyObject?
        jsonMessage["Date"] = Date() as AnyObject?
        
        let nick:String = UserDefaults.standard.object(forKey: "NickName") as! String
        let from:String = jsonMessage["NickName"] as! String
        
        if from == nick
        {
            jsonMessage["isFromUser"] = true as AnyObject
        }else{
            jsonMessage["isFromUser"] = false as AnyObject
        }
        
        let channelRef:Channel! = self.channelsIndex!.object(forKey: channel as String) as! Channel
        channelRef.unRead! += 1;
        channelRef.messages?.add(jsonMessage)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "newMessage"), object: nil, userInfo: jsonMessage)
    }
    
    func loadChannels(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        channels = NSMutableArray(contentsOfFile: documentsPath + "/channels.plist")
        
        if channels == nil
        {
            channels = NSMutableArray()
        }else
        {
            let temp: NSMutableArray = NSMutableArray()
            for obj in channels! as [AnyObject]
            {
                let channel:Channel = Channel(name: obj as! String)
                temp.add(channel)
                channelsIndex?.setObject(channel, forKey: obj as! String as NSCopying)
            }
            channels = temp
        }
    }
    
    
    /**
     * Occurs when the client connects.
     *
     * @param ortc The ORTC object.
     */
    func onConnected(_ ortc: OrtcClient){
        NSLog("CONNECTED")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ortcConnect"), object: nil)
        
        if channels != nil && channels!.count > 0 {
            for i in 0...(channels!.count - 1)
            {
                let channel:Channel = channels?.object(at: i) as! Channel
                subscribeChannel(channel.name! as String)
            }
        }
    }
    /**
     * Occurs when the client disconnects.
     *
     * @param ortc The ORTC object.
     */
    
    func onDisconnected(_ ortc: OrtcClient){
    
    }
    /**
     * Occurs when the client subscribes to a channel.
     *
     * @param ortc The ORTC object.
     * @param channel The channel name.
     */
    
    func onSubscribed(_ ortc: OrtcClient, channel: String){
        NSLog("did subscribe %@", channel)
    }
    /**
     * Occurs when the client unsubscribes from a channel.
     *
     * @param ortc The ORTC object.
     * @param channel The channel name.
     */
    
    func onUnsubscribed(_ ortc: OrtcClient, channel: String){
    
    }
    /**
     * Occurs when there is an exception.
     *
     * @param ortc The ORTC object.
     * @param error The occurred exception.
     */
    
    func onException(_ ortc: OrtcClient, error: NSError){
        let desc:String? = ((error.userInfo as NSDictionary).object(forKey: "NSLocalizedDescription") as? String)
        if desc != nil && desc == "Unable to get URL from cluster (http://ortc-developers.realtime.co/server/2.1/)" || desc == "Unable to get URL from cluster (https://ortc-developers.realtime.co/server/ssl/2.1/)"
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "noConnection"), object: nil)
            NSLog("%@", desc!)
        }
        
    }
    /**
     * Occurs when the client attempts to reconnect.
     *
     * @param ortc The ORTC object.
     */
    
    func onReconnecting(_ ortc: OrtcClient){
    
    }
    /**
     * Occurs when the client reconnects.
     *
     * @param ortc The ORTC object.
     */
    
    func onReconnected(_ ortc: OrtcClient){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ortcConnect"), object: nil)
    }
    

    


    
    
    
    
    
    
    
}
