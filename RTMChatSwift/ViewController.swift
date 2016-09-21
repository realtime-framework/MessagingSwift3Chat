//
//  ViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 14/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textNick: UITextField!
    @IBOutlet weak var buttonChatRooms: UIButton!
    @IBOutlet weak var labelState: UILabel!    
    @IBOutlet weak var labelWelcome: UILabel!
    var isConnect:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "RTMChat swift"
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ortcConnect), name: NSNotification.Name(rawValue: "ortcConnect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setInterface), name: NSNotification.Name(rawValue: "noConnection"), object: nil)
        self.disableBt()
        self.setInterface()
        
        textNick.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserDefaults.standard.setValue(textNick.text, forKey: "NickName")
        UserDefaults.standard.synchronize()
        textField.resignFirstResponder()
        self.setConnectState()
        return true
    }
    
    func setInterface()
    {
        let user:String? = UserDefaults.standard.object(forKey: "NickName") as! String?
        buttonChatRooms.layer.masksToBounds = true
        buttonChatRooms.layer.cornerRadius = 6
        buttonChatRooms.layer.masksToBounds = true
        buttonChatRooms.clipsToBounds = true
        
        
        labelState.layer.masksToBounds = true
        labelState.layer.cornerRadius = 6
        labelState.layer.masksToBounds = true
        labelState.clipsToBounds = true
        
        if user != nil
        {
            textNick.isHidden = true
            
            labelWelcome.text = "Welcome " + user!
            labelWelcome.isHidden = false
            if isConnect {
                self.enableBt()
            }

        }else
        {
            textNick.isHidden = false
            labelWelcome.isHidden = true
        }
        
                labelState.layer.borderColor = UIColor.black.cgColor
        labelState.layer.borderWidth = 1
        labelState.backgroundColor = UIColor.gray
        labelState.text = "Not connected"
    }
    
    func disableBt(){
        buttonChatRooms.isEnabled = false
        buttonChatRooms.backgroundColor = UIColor.gray
        buttonChatRooms.layer.borderColor = UIColor.black.cgColor
        buttonChatRooms.layer.borderWidth = 1
    }
    
    func enableBt(){
        buttonChatRooms.isEnabled = true
        buttonChatRooms.backgroundColor = UIColor.lightGray
    }
    
    func setConnectState(){
        let user:String? = UserDefaults.standard.object(forKey: "NickName") as! String?
        if user != nil
        {
            textNick.isHidden = true
            
            labelWelcome.text = "Welcome " + user!
            labelWelcome.isHidden = false
            if isConnect {
                self.enableBt()
            }

            if isConnect {
                self.enableBt()
            }
            
        }

    }

    func ortcConnect()
    {
        self.isConnect = true
        self.setConnectState()

        labelState.text = "Ortc is connected"
        labelState.backgroundColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }


}

