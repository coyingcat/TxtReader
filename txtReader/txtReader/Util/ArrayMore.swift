//
//  ArrayMore.swift

//
//  
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
