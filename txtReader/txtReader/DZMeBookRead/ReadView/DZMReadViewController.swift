//
//  ReadViewController.swift

//
//  
//

import UIKit

class ReadViewController: ViewController {
    
    
    
    // 需要两个对象， 当前页阅读记录 和 阅读对象
    
    /// 当前页阅读记录对象
    var recordModel:ReadRecordModel!

    /// 阅读对象  (  用于显示书名以及书籍首页显示书籍信息  )
    weak var readModel:ReadModel!
    
    /// 顶部状态栏
    var topView:ReadViewStatusTopView!
    
    /// 底部状态栏
    var bottomView:ReadViewStatusBottomView!
    
    /// 阅读视图
    private var readView:ReadView!
    
    /// 书籍首页视图
    private var homeView:ReadHomeView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 设置阅读背景
        view.backgroundColor = ReadConfigure.shared.bgColor
        
        // 刷新阅读进度
        
        addSubviews()
        reloadProgress()
    }
    
    func addSubviews() {
        
        // 阅读使用范围
        let readRect = READ_RECT
        
        // 顶部状态栏
        topView = ReadViewStatusTopView()
        topView.bookName.text = readModel.bookID
        topView.chapterName.text = recordModel.chapterModel.name
        view.addSubview(topView)
        topView.frame = CGRect(x: readRect.minX, y: readRect.minY, width: readRect.width, height: READ_STATUS_TOP_VIEW_HEIGHT)
        
        // 底部状态栏
        bottomView = ReadViewStatusBottomView()
        view.addSubview(bottomView)
        bottomView.frame = CGRect(x: readRect.minX, y: readRect.maxY - READ_STATUS_BOTTOM_VIEW_HEIGHT, width: readRect.width, height: READ_STATUS_BOTTOM_VIEW_HEIGHT)
        
        // 阅读视图
        initReadView()
    }
    
    /// 初始化阅读视图
    func initReadView() {
        
        // 是否为书籍首页
        if recordModel.pageModel.isHomePage {
            
            topView.isHidden = true
            bottomView.isHidden = true
            
            homeView = ReadHomeView()
            homeView.readModel = readModel
            view.addSubview(homeView)
            homeView.frame = READ_VIEW_RECT
            
        }else{
            
            readView = ReadView()
            readView.contentPage = recordModel.contentAttributedString
            view.addSubview(readView)
            readView.frame = READ_VIEW_RECT
        }
    }
    
    /// 刷新阅读进度显示
    private func reloadProgress() {
        switch ReadConfigure.shared.progressType {
        case .total:
            // 总进度
             
             // 当前阅读进度
             let progress:Float = readModel.progress(readTotal: recordModel)
            
             // 显示进度
             bottomView.progress.text = progress.readTotalProgress
        default:
            // 分页进度
            
            // 显示进度
            bottomView.progress.text = "\(recordModel.page + 1)/\(recordModel.chapterModel!.pageCount)"
        }
    }
    

}
