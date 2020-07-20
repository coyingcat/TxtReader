//
//  IndexPathMore.swift
//  DZMeBookRead
//
//  Created by Jz D on 2020/7/16.
//  Copyright © 2020 DZM. All rights reserved.
//

import Foundation


extension NSNumber{
    var ip: IndexPath{
        IndexPath(row: intValue, section: 0)
    }
}


extension Int{
    var ip: IndexPath{
        IndexPath(row: self, section: 0)
    }
}
