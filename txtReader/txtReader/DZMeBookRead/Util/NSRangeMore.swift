//
//  NSRangeMore.swift
//  DZMeBookRead
//
//  Created by Jz D on 2020/7/15.
//  Copyright © 2020 DZM. All rights reserved.
//

import Foundation



extension NSRange{
    
    var rhs: Int{
        location + length
    }
    
    
    var center: Int{
        location + length / 2
    }
}
