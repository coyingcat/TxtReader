//
//  ReadViewBGController.swift

//
//  
//

import UIKit

class ReadViewBGController: ViewController {

    /// 当前页阅读记录
    var recordModel:ReadRecordModel!
    
    /// 目标视图(无值则跟阅读背景颜色保持一致)
    var targetView:UIView!
    
    /// imageView
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // imageView
        imageView.backgroundColor = ReadConfigure.shared.bgColor
        view.addSubview(imageView)
        imageView.frame = view.bounds
        
        // 显示背面
        funcTwo()
        
        // 清空视图
        targetView = nil
    }
    
    // MARK: 方式二
    
    /// 方式二
    private func funcTwo() {
        
        // 展示图片
        if targetView != nil {
            
            let rect = targetView.frame
            
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
            
            let context = UIGraphicsGetCurrentContext()
            
            let transform = CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: rect.size.width, ty: 0.0)
            
            context?.concatenate(transform)
            
            targetView.layer.render(in: context!)
            
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }
    
}
