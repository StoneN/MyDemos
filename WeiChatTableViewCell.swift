//
// Created by StoneNan on 2017/5/27.
// Copyright (c) 2017 StoneNan. All rights reserved.
//

import UIKit

class WeiChatTableViewCell: UITableViewCell {
    var customView: UIView!
    var bubbleImage: UIImageView!
    var avatarImage: UIImageView!
    var msgItem: MessageItem!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(data: MessageItem, reuseIdentifier cellId: String) {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        rebuildUserInterface()
    }

    func rebuildUserInterface() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        if (self.bubbleImage == nil) {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
        }

        let type = self.msgItem.mtype
        let width = self.msgItem.view.frame.size.width
        let height = self.msgItem.view.frame.size.height

        var x = (type == ChatType.someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right
        var y: CGFloat = 0

        if (self.msgItem.user.username != "") {
            let thisUser = self.msgItem.user

            let imageName = thisUser.avatar != "" ? thisUser.avatar : "noAvatar.png"
            self.avatarImage = UIImageView(image: UIImage(named: imageName))
            self.avatarImage.layer.cornerRadius = 9.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).cgColor
            self.avatarImage.layer.borderWidth = 1.0

            let avatarX = (type == ChatType.someone) ? 5 : self.frame.size.width - 55
            //头像居于消息顶部
            let avatarY: CGFloat = 0

            self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 50, height: 50)
            self.addSubview(self.avatarImage)

            //如果只有一行消息（消息框高度不大于头像）则将消息框居中于头像位置
            let delta = (50 - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)) / 2
            if (delta > 0) {
                y = delta
            }
            if (type == ChatType.someone) {
                x += 55
            }
            if (type == ChatType.mine) {
                x -= 55
            }
        }

        self.customView = self.msgItem.view
        self.customView.frame = CGRect(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top, width: width, height: height)
        
        self.addSubview(self.customView)

        if (type == ChatType.someone) {
            self.bubbleImage.image = UIImage(named: "yoububble.png")!.stretchableImage(withLeftCapWidth: 21, topCapHeight: 25)
        } else {
            self.bubbleImage.image = UIImage(named: "mebubble.png")!.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
                //.stretchableImage(withLeftCapWidth: 15, topCapHeight: 25)
        }
        self.bubbleImage.frame = CGRect(x: x, y: y, width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
}
