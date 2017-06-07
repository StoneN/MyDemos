//
// Created by StoneNan on 2017/5/27.
// Copyright (c) 2017 StoneNan. All rights reserved.
//

import UIKit


class WeiChatTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var bubbleSection: NSMutableArray!
    var chatDataSource: ChatDataSource!
    var snapInterval: TimeInterval!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        self.snapInterval = TimeInterval(60 * 60 * 24)
        
        self.bubbleSection = NSMutableArray()

        super.init(frame: frame, style: style)

        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.delegate = self
        self.dataSource = self
    }

    override func reloadData() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        
        var count = 0
        if (self.chatDataSource != nil) {
            count = self.chatDataSource.rowsForChatTable(self)
            if (count > 0) {
                let bubbleData = NSMutableArray(capacity: count)
                for i in 0 ..< count {
                    let object = self.chatDataSource.chatTableView(self, dataForRow: i)
                    bubbleData.add(object)
                }
                bubbleData.sort(comparator: sortDate)
                var last = ""
                var currentSection: NSMutableArray
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"

                for i in 0 ..< count {
                    let data = bubbleData[i] as! MessageItem
                    let dateStr = dateFormatter.string(from: data.date as Date)
                    if (dateStr != last) {
                        currentSection = NSMutableArray()
                        self.bubbleSection.add(currentSection)
                    }
                    (self.bubbleSection[self.bubbleSection.count - 1] as AnyObject).add(data)
                    last = dateStr
                }
            }
        }
        super.reloadData()

       //滑向最后一部分
        // 1.
//        let sectionIndex = self.bubbleSection.count - 1
//        let indexPath = IndexPath(row: (self.bubbleSection[sectionIndex] as AnyObject).count, section: sectionIndex)
//
//        self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
//      // 2.
        let offset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(offset, animated: true)
    }

    func sortDate(_ m1: Any, m2: Any) -> ComparisonResult {
        if ((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bubbleSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section >= self.bubbleSection.count) {
            return 1
        }
        return (self.bubbleSection[section] as AnyObject).count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return WeiChatTableHeaderViewCell.getHeight()
        }
        let section = self.bubbleSection[indexPath.section] as! NSMutableArray
        let data = section[indexPath.row - 1]
        let item = data as! MessageItem
        let height = max(item.insets.top + item.view.frame.size.height + item.insets.bottom, 52) + 17
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cellId = "HeaderCell"
            let headerCell = WeiChatTableHeaderViewCell(reuseIdentifier: cellId)
            let section = self.bubbleSection[indexPath.section] as! NSMutableArray
            let data = section[indexPath.row] as! MessageItem
            headerCell.setDate(data.date)
            return headerCell
        }
        let cellId = "ChatCell"
        let section = self.bubbleSection[indexPath.section] as! NSMutableArray
        let data = section[indexPath.row - 1]
        let cell = WeiChatTableViewCell(data: data as! MessageItem, reuseIdentifier: cellId)
        return cell
    }
}

