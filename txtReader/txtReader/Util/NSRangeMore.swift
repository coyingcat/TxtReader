//
//  NSRangeMore.swift

//
//  
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
