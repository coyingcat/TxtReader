//
//  DZMMagnifierView.h
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/30.
//  Copyright © 2019年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZMMagnifierView : UIWindow

/// 目标视图Window (注意: 传视图的Window 例子: self.view.window)
@property (nonatomic, weak, nullable) UIView *targetWindow;

/// 目标视图展示位置 (放大镜需要展示的位置)
@property (nonatomic, assign) CGPoint targetPoint;


/// 移除 (移除对象 并释放内部强引用)
- (void)remove:(nullable void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
