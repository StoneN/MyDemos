//
// Created by StoneNan on 2017/5/27.
// Copyright (c) 2017 StoneNan. All rights reserved.
//

import Foundation

class UserInfo: NSObject {
    var username: String = ""
    var avatar: String = ""

    init(name: String, avatar: String) {
        self.username = name
        self.avatar = avatar
    }
}
