//
//  IndexPathMore.swift

//
//  
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
