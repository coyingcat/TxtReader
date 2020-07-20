//
//  ArrayMore.swift
//  DZMeBookRead
//
//  Created by Jz D on 2020/7/16.
//  Copyright © 2020 DZM. All rights reserved.
//

import Foundation


extension Optional where Wrapped: Collection {
    var none: Bool{
        if let s = self, s.isEmpty == false{
            return false
        }
        else{
            return true
        }
    }
}
