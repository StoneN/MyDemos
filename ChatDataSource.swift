//
//  ChatDataSource.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/27.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

protocol ChatDataSource {
    func rowsForChatTable(_ tableView: WeiChatTableView) -> Int
    func chatTableView(_ tableView: WeiChatTableView, dataForRow: Int) -> MessageItem
}

