//
//  NotificationMore.swift
//  txtReader
//
//  Created by Jz D on 2020/7/22.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation




extension Notification.Name {
    
    /// 长按阅读视图通知
    static let readLongPress = Notification.Name("READ_LONG_PRESS_VIEW_NOTIFICATION")
    

}




public protocol NamespaceWrap{
    associatedtype WrapperType
    var readLongPress: WrapperType { get }
}

public extension NamespaceWrap{
    var readLongPress: NamespaceWrapper<Self> {
        return NamespaceWrapper(val: self)
    }
    
}

public protocol TypeWrapper{
    associatedtype WrappedType
    var wrapped: WrappedType { get }
    init(val: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapper{
    public let wrapped: T
    public init(val: T) {
        self.wrapped = val
    }
}






struct ReadLongPress {
     /// 长按阅读视图通知 info 数据 key
    static let k = "READ_KEY_LONG_PRESS_VIEW"
}


extension Bool: NamespaceWrap{}


extension TypeWrapper where WrappedType == Bool {

   

    var info: [String: NSNumber]{
        [ReadLongPress.k: NSNumber(value: true)]
    }

}


extension Notification: NamespaceWrap{}



extension TypeWrapper where WrappedType == Notification {

    var isOpen: Bool?{
        if let dict = wrapped.userInfo, dict.keys.contains(ReadLongPress.k), let isOpen = dict[ReadLongPress.k] as? NSNumber{
            return isOpen.boolValue
        }
        else{
            return nil
        }
    }

}
