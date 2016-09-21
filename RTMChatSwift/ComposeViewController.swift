//
//  ComposeViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 16/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit
import RealtimeMessaging_iOS_Swift3

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var navController: UINavigationBar!
    @IBOutlet weak var textAreaMessage: UITextView!
    var channel:Channel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textAreaMessage.delegate = self
        setInterface()
        countRemaning()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textAreaMessage.becomeFirstResponder()
    }
    
    
    func setInterface(){
        let leftItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ComposeViewController.cancel))
        let rightItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ComposeViewController.save))
        let navItem = UINavigationItem(title: "none")
        navItem.leftBarButtonItem = leftItem
        navItem.rightBarButtonItem = rightItem
        
        navController.pushItem(navItem, animated: false)
        
    }
    
    func save(){
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ortc:OrtcClient = ((app.ortc! as OrtcClass).ortc! as OrtcClient)
        
        let nick:String = UserDefaults.standard.object(forKey: "NickName") as! String
        
        let messageString:NSString = "\(nick):\(textAreaMessage.text!)" as NSString
        
        ortc.send(channel!.name! as NSString, message: messageString as String as String as NSString)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cancel(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return countRemaning()
    }
    
    func countRemaning() -> Bool{
        let text = textAreaMessage.text
        let remaming = 260 - (text?.lengthOfBytes(using: String.Encoding.utf8))!
        navController.topItem?.title =  "\(remaming) Remaning"
        
        if remaming > 0{
            return true
        }else{
            return false
        }

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
