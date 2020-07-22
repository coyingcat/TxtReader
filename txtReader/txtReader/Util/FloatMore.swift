//
//  FloatMore.swift

//
//  
//

import Foundation


extension Float{
    /// 总进度字符串
    var readTotalProgress: String {
        String(format: "%.1f%%", (floor(self * 1000) / 10))
    }
    
    
    var readSegmentProgress: String{
        "\(Int(self))"
    }
    
    
}
