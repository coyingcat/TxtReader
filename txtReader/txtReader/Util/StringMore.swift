//
//  StringMore.swift
//  txtReader
//
//  Created by Jz D on 2020/7/22.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation



extension String{
    
    
    /// 是否存在阅读记录
    
    /// 是否存在阅读对象
    var exists: Bool{
        KeyedArchiver.isExist(folderName: self, fileName: PersistKey.readObject)
    }
    
    
    /// 需要处理的章节标题
    var readChapterName: String{
        "\n\(self)\n\n"
    }
    
}
