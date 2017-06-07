//
//  WeiChatViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/27.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit



class WeiChatViewController: UIViewController, ChatDataSource, UITextFieldDelegate {

    var tableView: WeiChatTableView!
    var Chats: NSMutableArray!
    var me: UserInfo!
    var you: UserInfo!
    var txtMsg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatTable()
        setupSendPanel()
    }

    func setupSendPanel() {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 56, width: screenWidth, height: 56))

        sendView.backgroundColor = UIColor.lightGray
        sendView.alpha = 0.9

        txtMsg = UITextField(frame: CGRect(x: 7, y: 10, width: screenWidth - 95, height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor = UIColor.black
        txtMsg.font = UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send

        txtMsg.delegate = self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)

        let sendButton = UIButton(frame: CGRect(x: screenWidth - 80, y: 10, width: 72, height: 36))
        sendButton.backgroundColor = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        sendButton.addTarget(self, action: #selector(self.sendMessage), for: UIControlEvents.touchUpInside)
        
        sendButton.layer.cornerRadius = 6.0
        sendButton.setTitle("发送", for: UIControlState())
        sendView.addSubview(sendButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    func closeKeyboard() {
        txtMsg.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    func sendMessage() {
        let sender = txtMsg
        let thisChat = MessageItem(body: sender!.text! as NSString, user: me, date: Date(), mtype: ChatType.mine)
        let thatChat = MessageItem(body: "你说的是： \(sender!.text!)" as NSString, user: you, date: Date(), mtype: ChatType.someone)

        Chats.add(thisChat)
        Chats.add(thatChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()

        sender?.resignFirstResponder()
        sender?.text = ""
    }
    func setupChatTable() {
        self.tableView = WeiChatTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 56), style: .plain)
        self.tableView!.register(WeiChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name: "Xiaoming", avatar: "xiaoming.png")
        you = UserInfo(name: "Xiaohua", avatar: "xiaohua.png")
        
        let zero = MessageItem(body: "你好！", user: you, date: Date(timeIntervalSinceNow: -90096400), mtype: .someone)
        let zero1 = MessageItem(body: "嗨", user: me, date: Date(timeIntervalSinceNow: -90086400), mtype: .mine)
        let first = MessageItem(body: "你看这风景怎么样，我周末去苏州拍的！", user: me, date: Date(timeIntervalSinceNow: -90000600), mtype: .mine)
        let second = MessageItem(image: UIImage(named:"sz.png")!, user:me, date: Date(timeIntervalSinceNow: -90000290), mtype: .mine)
        let third = MessageItem(body: "太赞了，我也想去那看看呢！", user:you, date: Date(timeIntervalSinceNow: -90000060), mtype: .someone)
        let fouth = MessageItem(body: "嗯，下次我们一起去吧！", user:me, date: Date(timeIntervalSinceNow: -90000020), mtype: .mine)
        let fifth = MessageItem(body: "三年了，我终究没能看到这个风景", user:you, date: Date(timeIntervalSinceNow: 0), mtype: .someone)
        
        Chats = NSMutableArray()
        Chats.addObjects(from: [first, second, third, fouth, fifth, zero, zero1])
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView: WeiChatTableView) -> Int {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView: WeiChatTableView, dataForRow: Int) -> MessageItem {
        return Chats[dataForRow] as! MessageItem
    }
    
    

}
