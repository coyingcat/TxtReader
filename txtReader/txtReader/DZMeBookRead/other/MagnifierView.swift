//
//  MagnifierView.swift
//  txtReader
//
//  Created by Jz D on 2020/7/20.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit



struct MagnifierAnima {
    /// 动画时间
    static let time: TimeInterval = 0.08

    /// 放大比例
    static let scale: CGFloat = 1.3
    
    
    /// 放大区域
    static let wh: CGFloat = 120
}



// 放大镜
class MagnifierView: UIWindow {

      /// 目标视图Window (注意: 传视图的Window 例子: self.view.window)
    
    weak var targetWindow: UIView?{
        didSet{
            makeKeyAndVisible()
            UIView.animate(withDuration: MagnifierAnima.time) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
             
        }
    }
   

    
     /// 目标视图展示位置 (放大镜需要展示的位置)
    var _targetPoint = CGPoint.zero
    
    
    var targetPoint: CGPoint{
        get{
            _targetPoint
        }
        set{
            _targetPoint = newValue
            if targetWindow != nil{
               
                var anchor = CGPoint(x: _targetPoint.x, y:  self.center.y)
                if _targetPoint.y > bounds.height * 0.5{
                    anchor.y = targetPoint.y - self.bounds.height / 2
                }
                /// 放大镜位置偏移调整 (调整放大镜在原始位置上的偏移 默认: CGPointMake(0, -40))
                let offsetPoint = CGPoint(x: 0, y: -40)
                self.center = CGPoint(x: anchor.x + offsetPoint.x, y: anchor.y + offsetPoint.y)
                contentLayer.setNeedsLayout()
            }
        }
    }
    
    lazy var contentLayer = { () -> CALayer in
        let layer = CALayer()
        layer.frame = self.bounds
        layer.delegate = self
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    let coverOne = UIImageView(image: UIImage(named: "magnifier_0"))
    
    let coverTwo = UIImageView(image: UIImage(named: "magnifier_1"))
    
  
    
    init() {
        super.init(frame: CGRect.zero)
        
        
        frame = CGRect(x: 0, y: 0, width: MagnifierAnima.wh, height: MagnifierAnima.wh)
        layer.cornerRadius = MagnifierAnima.wh / 2
        layer.masksToBounds = true
        windowLevel = UIWindow.Level.alert
        layer.addSublayer(contentLayer)
    
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        coverOne.frame = CGRect(x: 0, y: 0, width: MagnifierAnima.wh, height: MagnifierAnima.wh)
        addSubview(coverOne)
         
         
        coverTwo.frame = CGRect(x: 0, y: 0, width: MagnifierAnima.wh, height: MagnifierAnima.wh)
        addSubview(coverTwo)
    }
    
    
    
    
    
    /// 移除 (移除对象 并释放内部强引用)
    func remove(done completionHandler: @escaping ()->Void){
        
        UIView.animate(withDuration: MagnifierAnima.time, animations: {
            self.coverOne.alpha = 0
            
            self.coverTwo.alpha = 0
            
            self.alpha = 0
            
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (finished) in
            self.coverOne.removeFromSuperview()
            
            self.coverTwo.removeFromSuperview()
            
            self.removeFromSuperview()
            
            completionHandler()
            
        }
       
        
        
    }
    
   
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.translateBy(x: MagnifierAnima.wh, y: MagnifierAnima.wh)
        /// 放大比例 默认: MV_SCALE
        ctx.scaleBy(x: MagnifierAnima.scale, y: MagnifierAnima.scale)
        ctx.translateBy(x: -1 * targetPoint.x, y: -1 * targetPoint.y)
        targetWindow?.layer.render(in: ctx)
    }
    
    

    required init?(coder: NSCoder) {
        fatalError()
    }
}

   
