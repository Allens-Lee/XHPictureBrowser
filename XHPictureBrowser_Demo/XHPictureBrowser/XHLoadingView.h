//
//  HZWaitingView.h
//  HZPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHLoadingViewType) {
    XHLoadingViewTypeLoopDiagram,           //环形
    XHLoadingViewTypePieDiagram,            //饼型
};

@interface XHLoadingView : UIView

@property (nonatomic, assign) XHLoadingViewType type;       ///加载进度指示器类型
@property (nonatomic, assign) CGFloat progress;             ///加载进度

@end
