//
//  MessagesViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 16/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var labelNoMessages: UILabel!
    var channel:Channel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMessages.dataSource = self
        tableMessages.delegate = self
        setInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.newMessage), name: NSNotification.Name(rawValue: "newMessage"), object: nil)
    }
    
    
    func newMessage(){
        tableMessages.reloadData()
    }

    func setInterface(){
        self.title = channel!.getName()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(MessagesViewController.edit))
        self.tableMessages.backgroundView = UIImageView(image: UIImage(named: "background.png"))
    }
    
    func edit(){
        let viewController:ComposeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Compose") as! ComposeViewController
        viewController.channel = channel
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if channel!.messages!.count > 0
        {
            labelNoMessages.isHidden = true
        }
        channel!.unRead! = 0;
        return channel!.messages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier = "MessageCellIdentifier"
        
        var cell:MessageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? MessageTableViewCell
        
        if cell == nil
        {
            cell = MessageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        let message:NSDictionary = channel!.messages!.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        cell!.setMessage(message as! [AnyHashable: Any])
        
        return cell!

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message:NSDictionary = channel!.messages!.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let bublesize = SpeechBubbleView.sizeForText(message.object(forKey: "Message") as! String as NSString) as CGSize
        
        return bublesize.height + 16
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
