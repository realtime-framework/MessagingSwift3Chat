//
//  ChannelsViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 15/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ChannelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableChannels: UITableView!
    var channels: NSMutableArray?
    let newChannel: UITextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableChannels.dataSource = self
        tableChannels.delegate = self
        
        self.setInterface()
        let app:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        channels = app.ortc?.channels
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelsViewController.newMessage), name: NSNotification.Name(rawValue: "newMessage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableChannels.reloadData()
    }
    
    func newMessage()
    {
        tableChannels.reloadData()
    }
    
    
    func setInterface(){
        self.title = "Chat Rooms"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChannelsViewController.edit))
        self.tableChannels.backgroundView = UIImageView(image: UIImage(named: "background.png"))
    }
    
    func edit(){
        tableChannels.isEditing = true;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChannelsViewController.endEdit))
        tableChannels.reloadData()
    }

    func endEdit(){
        tableChannels.isEditing = false;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChannelsViewController.edit))
        tableChannels.reloadData()
    }
    
    
    func saveChannel(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let temp:NSArray = app.ortc!.channelsIndex!.allKeys as NSArray
        temp.write(toFile: documentsPath + "/channels.plist", atomically: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing && (indexPath as NSIndexPath).row == channels!.count
        {
            return UITableViewCellEditingStyle.insert
        }
        else{
            return UITableViewCellEditingStyle.delete
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.insert
        {
            let channel1 = newChannel.text!
            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            app.ortc?.subscribeChannel(newChannel.text!)
            let channel:Channel = Channel(name: newChannel.text!)
            app.ortc?.channels?.add(channel)
            app.ortc?.channelsIndex?.setObject(channel, forKey: channel.name! as NSCopying)
            
            newChannel.text = ""
            saveChannel()
        }else if editingStyle == UITableViewCellEditingStyle.delete{
            
            let channel:Channel = channels!.object(at: (indexPath as NSIndexPath).row) as! Channel
            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            app.ortc?.channels?.remove(channel)
            app.ortc?.channelsIndex?.removeObject(forKey: channel.name!)
            saveChannel()
        }
        tableChannels.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell()
        }
        
        cell?.backgroundColor = UIColor.clear
        
        if tableChannels.isEditing && (indexPath as NSIndexPath).row == channels!.count
        {
            newChannel.frame = CGRect(x: 10, y: 8, width: 250, height: cell!.frame.size.height - 20)
            newChannel.placeholder = "Enter Channel Name Here"
            newChannel.delegate = self
            newChannel.borderStyle = UITextBorderStyle.roundedRect
            newChannel.font = UIFont(name: "Helvetica Neue", size: 16.0)
            
            cell?.contentView.addSubview(newChannel)
            return cell!
        }
        
        let subViews: NSArray = cell!.contentView.subviews as NSArray
        for i in 0 ..< subViews.count
        {
            let subview:UIView = subViews.object(at: i) as! UIView
            subview.removeFromSuperview()
        }
        
        let channel = channels!.object(at: (indexPath as NSIndexPath).row) as? Channel
        cell?.textLabel?.text = channel!.getName()
        cell?.textLabel?.textColor = UIColor.white
        
        if channel!.unRead > 0 {
            
            let unread:Int = channel!.unRead!
            let unreadMsg:String = String(unread)
            
            let unreadLabel:UILabel = UILabel();
            unreadLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            unreadLabel.text = unreadMsg;
            unreadLabel.textColor = UIColor.white
            unreadLabel.backgroundColor = UIColor(red: 220/255.0, green: 55/255.0, blue: 35/255.0, alpha: 1.0)
            unreadLabel.numberOfLines = 1
            unreadLabel.layer.borderColor = UIColor.darkGray.cgColor;
            unreadLabel.layer.borderWidth = 1.0;
            unreadLabel.layer.cornerRadius = 6.0;
            unreadLabel.textAlignment = NSTextAlignment.center;
            
            let maximumLabelSize:CGFloat = 20.0;
            let expectedLabelSize:CGSize = unreadMsg.size(attributes: [NSFontAttributeName: unreadLabel.font.withSize(maximumLabelSize)])
            
            unreadLabel.frame = CGRect(x: 250, y: (cell!.contentView.frame.size.height - (expectedLabelSize.height + 5))/2, width: expectedLabelSize.width + 5, height: expectedLabelSize.height + 5);
            cell!.contentView.addSubview(unreadLabel);
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows:Int = channels!.count
        if tableView.isEditing == true {
            return rows + 1
        }
        
        return channels!.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let destination = segue.destination as! MessagesViewController
        let selected = tableChannels.indexPathForSelectedRow
        if selected != nil{
            destination.channel = channels!.object(at: ((selected as NSIndexPath?)?.row)!) as? Channel
            tableChannels.deselectRow(at: tableChannels.indexPathForSelectedRow!, animated: false)
        }
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        return true
//    }

}
