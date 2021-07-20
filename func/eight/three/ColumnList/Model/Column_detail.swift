//
//  Column_detail.swift
//  SwiftSocket
//
//  Created by Jz D on 2021/6/29.
//  Copyright © 2021 swift. All rights reserved.
//

import Foundation



struct Column_detail: Decodable {
    
    let introduction: String?
    let netname: String
    let playTotal: Int
    
    
    let canEdit: Bool
    
    
    
    let profile_photo: String
    let title: String
    let cover: String

    
    let content: [Column_detail_oreo]
     
}





extension Column_detail{
    
    var hidMk: Bool{
        canEdit == false
    }
}





struct Column_detail_oreo: Decodable{
    
    
    let contentID: Int
    let modifyTime: String
    let playTotal: Int
    
    
    let cover: String
    let title: String
}




struct Influencer_list_donut: Decodable{
    
    
    let columnID: Int
    let modifyTime: String
    let playTotal: Int
    
    
    let cover: String
    let title: String
    
    let isHistory: Bool?
    let contentTotal: Int?
}


extension Influencer_list_donut{
    
    var contentNum: String{
        if let n = contentTotal{
            return String(n)
        }
        else{
            return ""
        }
    }
    
    
    
    var pTotal: String{
        String(playTotal)
    }
}



struct List_follow_Cupcake: Decodable{
    
    
    let userID: Int
    let profilePhoto: String
    let followers: Int
    
    
    let contents: Int
    let netName: String
    let follews: Int
    
    
    let hasFollowed: Int
}
