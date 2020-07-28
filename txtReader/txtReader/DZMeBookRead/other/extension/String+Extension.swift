//
//  String+Extension.swift

//
//  
//

import UIKit

extension String {
    
 
    var bool:Bool {
        (self as NSString).boolValue
    }
    
    var integer:NSInteger {
        (self as NSString).integerValue
    }
    
    var float:Float {
        (self as NSString).floatValue
    }
    
    var cgFloat:CGFloat {
        CGFloat(self.float)
    }
    
    var double:Double {
        (self as NSString).doubleValue
    }
    
    /// 文件后缀(不带'.')
    var pathExtension:String {
        (self as NSString).pathExtension
    }
    
    /// 文件名(带后缀)
    var lastPathComponent:String {
        (self as NSString).lastPathComponent
    }
    
    /// 文件名(不带后缀)
    var deletingPathExtension:String {
        (self as NSString).deletingPathExtension
    }
    
    /// 去除首尾空格
    var removeSpaceHeadAndTail:String {
        trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// 去除首尾换行
    var removeEnterHeadAndTail:String {
        trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// 去除首尾空格和换行
    var removeSEHeadAndTail:String {
        trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    /// 去掉所有空格
    var removeSapceAll:String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "")
    }
    
    /// 去除所有换行
    var removeEnterAll:String {
        replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /// 去除所有空格换行
    var removeSapceEnterAll:String {
        removeSapceAll.replacingOccurrences(of: "\n", with: "")
    }
    
    /// 是否为整数
    var isInt:Bool {
        
        let scan = Scanner(string: self)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
    }

    /// 是否为空格
    var isSpace:Bool {
        
        if (self == " ") || (self == "　") { return true }
        
        return false
    }
    
    /// 是否为空格或者回车
    var isSpaceOrEnter:Bool {
        
        if isSpace || (self == "\n") { return true }
        
        return false
    }
    
    /// MD5加密
    var md5:String {
        
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// 转JSON
    var json:Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        
        return json
    }
    
    /// 是否包含指定字符串
    func range(_ string: String) ->NSRange {
        
        return (self as NSString).range(of: string)
    }
    
    /// 截取字符串
    func substring(_ range:NSRange) ->String {
        
        return (self as NSString).substring(with: range)
    }
    
    /// 处理带中文的字符串
    func addingPercentEncoding(_ characters: CharacterSet = .urlQueryAllowed) ->String {
        
        return (self as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    /// 正则替换字符
    func replacingCharacters(_ pattern:String, _ template:String) ->String {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, count), withTemplate: template)
            
        } catch {return self}
    }
    
    /// 正则搜索相关字符位置
    func matches(_ pattern:String) ->[NSTextCheckingResult] {
        
        if isEmpty {return []}
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, count))
            
        } catch {return []}
    }
    
    /// 计算大小
    func size(_ font:UIFont, _ size:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize {
        
        let string = self as NSString
        
        return string.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [.font:font], context: nil).size
    }
}

extension NSAttributedString {
    
    /// 计算size
    func size(_ size:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize{
        
        return self.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], context: nil).size
    }
    
    /// 扩展拼接
    func add<T:NSAttributedString>(_ string:T) ->NSAttributedString {
        
        let attributedText = NSMutableAttributedString(attributedString: self)
        
        attributedText.append(string)
        
        return attributedText
    }
}
