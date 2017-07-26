//
//  Goal.swift
//  EZGuitar
//
//  Created by Local Account 436-25 on 7/20/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import Foundation

class Goal {
    var name = "Default"
    var goalAmount = -1
    var dueDate = Date()
    
    init(name: String, goalAmount: Int, dueDate: Date) {
        self.name = name
        self.goalAmount = goalAmount
        self.dueDate = dueDate
    }
}
