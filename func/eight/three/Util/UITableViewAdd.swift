//
//  UITableViewAdd.swift
//  musicSheet
//
//  Created by 杰克 伦敦 on 2019/8/23.
//  Copyright © 杰克 伦敦   2300. All rights reserved.
//

import UIKit



protocol CellReuse: AnyObject {
    static var id: String {get}
    
    
}



extension UITableViewCell: CellReuse{
    static var id: String{
        return String(describing: self)
        
    }
    
    
    static let placeHolder = UITableViewCell()

}





extension UITableView{
    
    
    func register<T: CellReuse>(for cellNib: T.Type){
        
        register(UINib(nibName: cellNib.id, bundle: nil), forCellReuseIdentifier: cellNib.id)
        
    }

    
    
    
    
    func dequeue<T: CellReuse>(for cellNib: T.Type, ip indexPath: IndexPath) -> T{
        let cell = dequeueReusableCell(withIdentifier: cellNib.id, for: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(rgb: 0xF0F0F0)
        cell.selectedBackgroundView = bgColorView
        return cell as! T
        
    }
    
    func cell<T: CellReuse>(_ type: T.Type, at index: Int) ->T{
        return cellForRow(at: IndexPath(row: index, section: 0)) as! T
    }
    
    func cell<T: CellReuse>(_ type: T.Type, one index: Int) ->T{
        return cellForRow(at: IndexPath(row: index, section: 1)) as! T
    }
    
    
    func cell<T: CellReuse>(_ type: T.Type, ip index: IndexPath) ->T{
        return cellForRow(at: index) as! T
    }
}














extension UIScrollView{
    var isScrolling: Bool{
        layer.animation(forKey: "bounds") != nil
    }
    
    var notScrolling: Bool{
        layer.animation(forKey: "bounds") == nil
    }
}






extension UICollectionView{
    func rectForRow(at indexPath: IndexPath) -> CGRect{
        var f = CGRect.zero
        if let position = layoutAttributesForItem(at: indexPath){
            f = position.frame
        }
        return f
    }
}
