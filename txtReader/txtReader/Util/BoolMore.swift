//
//  BoolMore.swift
//  txtReader
//
//  Created by Jz D on 2020/7/22.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation


extension Bool{
    var val: Int{
        var value = 0
        if self{
            value = 1
        }
        return value
    }
    
    var negVal: Int{
        1 - val
    }
}



