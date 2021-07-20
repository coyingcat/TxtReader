//
//  Square_First.swift
//  petit
//
//  Created by Jz D on 2021/6/24.
//  Copyright © 2021 swift. All rights reserved.
//

import Foundation


struct Square_Zero: Decodable{
    
    
    let columns: [Column_Top]
    
    
    var contents: [Square_First]
}




struct Column_Top: Decodable{
    let cover: String
    
    let title: String
    let columnID: Int
    
}






struct Square_First: Decodable {
    
    
    let column : String
    let introduction : String
    
    let userID: Int
    
    
    
    let contentID : Int    //
    let playTotal : Int    //   
    
    
    let profilePhoto : String
    let title : String
    let cover : String
    let netName : String
    
    
    
    let createTime : String
    
     
}
