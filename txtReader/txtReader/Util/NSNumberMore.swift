//
//  NSNumberMore.swift

//
//  
//

import Foundation


func >= ( lhs: NSNumber, rhs: NSNumber) -> Bool {
    lhs.intValue >= rhs.intValue
}


func < ( lhs: NSNumber, rhs: NSNumber) -> Bool {
    lhs.intValue < rhs.intValue
}



func != ( lhs: NSNumber, rhs: Int) -> Bool {
    lhs.intValue != rhs
}




func != ( lhs: NSNumber?, rhs: Int) -> Bool {
    lhs?.intValue != rhs
}


func == ( lhs: NSNumber, rhs: Int) -> Bool {
    lhs.intValue == rhs
}




func == ( lhs: NSNumber?, rhs: Int) -> Bool {
    lhs?.intValue == rhs
}




extension Optional where Wrapped == NSNumber {
      var intVal: Int{
          self?.intValue ?? 0
      }
}


extension Optional where Wrapped == Int {
      var val: Int{
          self ?? 0
      }
}



extension Optional where Wrapped == Bool {
      var ok: Bool{
            if let isOK = self{
                return isOK
            }
            else{
                return false
            }
      }
}

