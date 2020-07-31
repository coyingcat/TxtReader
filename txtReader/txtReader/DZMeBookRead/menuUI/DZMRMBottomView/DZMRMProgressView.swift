//
//  RMProgressView.swift

//
//  
//

import UIKit

class RMProgressView: RMBaseView,ASValueTrackingSliderDelegate,ASValueTrackingSliderDataSource {
    
    /// 上一章
    private var previousChapter = UIButton(type:.custom)
    
    /// 进度
    private var slider = ASValueTrackingSlider()
    
    /// 下一章
    private var nextChapter = UIButton(type:.custom)
    
    
    override init(read menu: ReadMenu) {
        super.init(read: menu)
        
        backgroundColor = UIColor.clear
        
        // 上一章
        
        previousChapter.titleLabel?.font = FONT_SA_14
        previousChapter.setTitle("上一章", for: .normal)
        previousChapter.setTitleColor(READ_COLOR_MENU_COLOR, for: .normal)
        previousChapter.addTarget(self, action: #selector(clickPreviousChapter), for: .touchUpInside)
        addSubview(previousChapter)
        
        // 下一章
        nextChapter.titleLabel?.font = FONT_SA_14
        nextChapter.setTitle("下一章", for: .normal)
        nextChapter.setTitleColor(READ_COLOR_MENU_COLOR, for: .normal)
        nextChapter.addTarget(self, action: #selector(clickNextChapter), for: .touchUpInside)
        addSubview(nextChapter)
        
        // 进度条
        slider.delegate = self
        slider.dataSource = self
        slider.setThumbImage(UIImage(named:"slider")!.withRenderingMode(.alwaysTemplate), for: .normal)
        // 设置显示进度保留几位小数 (由于重写了 dataSource 则不用不到该属性了)
        // slider.setMaxFractionDigitsDisplayed(0)
        // 设置气泡背景颜色
        slider.popUpViewColor = READ_COLOR_MAIN
        // 设置气泡字体颜色
        slider.textColor = READ_COLOR_MENU_COLOR
        // 设置气泡字体以及字体大小
        slider.font = UIFont(name: "Futura-CondensedExtraBold", size: 22)
        // 设置气泡箭头高度
        slider.popUpViewArrowLength = SPACE_SA_5
        // 设置当前进度颜色
        slider.minimumTrackTintColor = READ_COLOR_MAIN
        // 设置总进度颜色
        slider.maximumTrackTintColor = READ_COLOR_MENU_COLOR
        // 设置当前拖拽圆圈颜色
        slider.tintColor = READ_COLOR_MENU_COLOR
        addSubview(slider)
        reloadProgress()
    }
    
    /// 刷新阅读进度显示
    func reloadProgress() {
       
        // 有阅读数据
        let readModel = readMenu.vc.readModel
        
        // 有阅读记录以及章节数据
        if readModel.recordModel?.chapterModel != nil{
            
            if ReadConfigure.shared.progressType == .total { // 总进度
                
                slider.minimumValue = 0
                slider.maximumValue = 1
                slider.value = readModel.progress(readTotal: readModel.recordModel)
                
            }else if let record = readModel.recordModel{ // 分页进度
                
                slider.minimumValue = 1
                slider.maximumValue = record.chapterModel.pageCount.floatValue
                slider.value = record.page.floatValue + 1
            }
            
        }else{ // 没有则清空
            
            slider.minimumValue = 0
            slider.maximumValue = 0
            slider.value = 0
        }
    }
    
    /// 上一章
    @objc func clickPreviousChapter() {
        
        readMenu?.delegate?.readMenuClickPreviousChapter(readMenu: readMenu)
    }
    
    /// 下一章
    @objc func clickNextChapter() {
        
        readMenu?.delegate?.readMenuClickNextChapter(readMenu: readMenu)
    }
    
    // MARK: ASValueTrackingSliderDataSource
    
    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String{
        switch ReadConfigure.shared.progressType {
        case .total:
            // 总进度
            
            // 如果有需求可显示章节名
            return value.readTotalProgress
        default:
            // 分页进度
            
            return value.readSegmentProgress
        }
    }
    
    // MARK: -- ASValueTrackingSliderDelegate

    /// 进度显示将要隐藏
    func sliderWillHidePopUpView(_ slider: ASValueTrackingSlider!) {
  
        if ReadConfigure.shared.progressType == .total { // 总进度
            
            // 有阅读数据
            let readModel = readMenu.vc.readModel
            
            // 有阅读记录以及章节数据
            if readModel.recordModel?.chapterModel != nil{
                
                // 总章节个数
                let count = (readModel.chapterListModels.count - 1)
                
                // 获得当前进度的章节索引
                let index = Int(Float(count) * slider.value)
                
                // 获得章节列表模型
                let chapterListModel = readModel.chapterListModels[index]
                
                // 页码
                let toPage = (index == count) ? ReadingConst.lastPage : 0
                
                // 传递
                readMenu?.delegate?.readMenuDraggingProgress(readMenu: readMenu, toChapterID: chapterListModel.id, toPage: toPage)
            }
            
        }else{ // 分页进度
            
            readMenu?.delegate?.readMenuDraggingProgress(readMenu: readMenu, toPage: Int(slider.value - 1))
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        let buttonW = SPACE_SA_55
        
        // 上一章
        previousChapter.frame = CGRect(x: SPACE_SA_5, y: 0, width: buttonW, height: h)
        
        // 下一章
        nextChapter.frame = CGRect(x: w - buttonW - SPACE_SA_5, y: 0, width: buttonW, height: h)
        
        // 进度条
        let sliderX = previousChapter.frame.maxX + SPACE_SA_10
        let sliderW = w - 2 * sliderX
        slider.frame = CGRect(x: sliderX, y: 0, width: sliderW, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
