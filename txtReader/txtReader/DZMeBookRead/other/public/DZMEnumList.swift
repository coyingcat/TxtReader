//
//  EnumList.swift

//
//  
//

import UIKit



/// 阅读翻页类型
enum EffectType: Int {
    /// 仿真
    case simulation
    /// 平移
    case translation
    /// 滚动
    case scroll
    /// 无效果
    case no
}

/// 阅读字体类型
enum FontType: Int {
    /// 系统
    case system
    /// 黑体
    case one
    /// 楷体
    case two
    /// 宋体
    case three
}

/// 阅读内容间距类型
enum SpacingType: Int {
    /// 大间距
    case big
    /// 适中间距
    case middle
    /// 小间距
    case small
}

/// 阅读进度类型
enum ProgressType: Int {
    /// 总进度
    case total
    /// 分页进度
    case page
}

/// 分页内容是以什么开头
enum PageHeadType: Int {
    /// 章节名
    case chapterName = 0
    /// 段落
    case paragraph
    /// 行内容
    case line
}
