//
//  MessageTableViewCell.swift
//  RTMChatSwift
//
//  Created by joao caixinha on 02/02/16.
//  Copyright © 2016 Internet Business Technologies. All rights reserved.
//

import Foundation
import UIKit

var color: UIColor? = nil

class MessageTableViewCell: UITableViewCell {
    
    var bubbleView:SpeechBubbleView?
    var label:UILabel?
    
    override class func initialize() {
        if self == MessageTableViewCell.self {
            color = UIColor(red: 220 / 255.0, green: 225 / 255.0, blue: 240 / 255.0, alpha: 1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            // Create the speech bubble view
            self.bubbleView = SpeechBubbleView(frame: CGRect.zero)
            //_bubbleView.backgroundColor = color;
            self.bubbleView!.backgroundColor = UIColor.clear
            self.bubbleView!.isOpaque = true
            self.bubbleView!.clearsContextBeforeDrawing = false
            self.bubbleView!.contentMode = .redraw
            self.bubbleView!.autoresizingMask = UIViewAutoresizing()
            self.contentView.addSubview(bubbleView!)
            // Create the label
            self.label = UILabel(frame: CGRect.zero)
            //_label.backgroundColor = color;
            self.label!.backgroundColor = UIColor.clear
            self.label!.isOpaque = true
            self.label!.clearsContextBeforeDrawing = false
            self.label!.contentMode = .redraw
            self.label!.autoresizingMask = UIViewAutoresizing()
            self.label!.font = UIFont.systemFont(ofSize: 13)
            self.label!.textColor = UIColor(red: 64 / 255.0, green: 64 / 255.0, blue: 64 / 255.0, alpha: 1.0)
            self.contentView.addSubview(label!)
    }
    
    override func layoutSubviews() {
        // This is a little trick to set the background color of a table view cell.
        super.layoutSubviews()
        //self.backgroundColor = color;
        self.backgroundColor = UIColor.clear
    }
    
    func setMessage(_ message: [AnyHashable: Any]) {
        var point: CGPoint = CGPoint.zero
        // We display messages that are sent by the user on the left-hand side of
        // the screen. Incoming messages are displayed on the right-hand side.
        var senderName: String
        var bubbleType: BubbleType
        let bubbleSize: CGSize = SpeechBubbleView.sizeForText((message["Message"] as! String as NSString))
        if (message["isFromUser"] as! Bool) == false  {
            bubbleType = BubbleType.lefthand
            senderName = (message["NickName"] as! String)
            self.label!.textAlignment = .left
        }
        else {
            bubbleType = BubbleType.righthand
            senderName = (message["NickName"] as! String)
            point.x = self.bounds.size.width - bubbleSize.width
            self.label!.textAlignment = .right
        }
        // Resize the bubble view and tell it to display the message text
        var rect: CGRect = CGRect()
        rect.origin = point
        rect.size = bubbleSize
        self.bubbleView!.frame = rect
        bubbleView!.setText((message["Message"] as! String as NSString), bubbleType: bubbleType)
        // Format the message date
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy, HH:mm"
        let dateString: String = formatter.string(from: (message["Date"] as! Date))
        // Set the sender's name and date on the label
        self.label!.text = "\(senderName) @ \(dateString)"
        self.label!.textColor = UIColor.white
        label!.sizeToFit()
        self.label!.frame = CGRect(x: 8, y: bubbleSize.height, width: self.contentView.bounds.size.width - 16, height: 16)
    }
}
