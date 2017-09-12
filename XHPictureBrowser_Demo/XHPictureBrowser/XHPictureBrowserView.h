//
//  XHPictureBrowserView.h
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHPictureBrowserCell.h"

@interface XHPictureBrowserView : UIView

///总项数
@property (nonatomic, assign) NSInteger itemCount;

///默认显示的序号
@property (nonatomic, assign) NSInteger touchIndex;

///默认显示的图片视图
@property (nonatomic, strong) UIImageView *touchImageView;

///图片视图数组
@property (nonatomic, strong) NSArray *imageViews;

///图片链接数组
@property (nonatomic, strong) NSArray *imageUrls;

///单击隐藏回调  index：单击对应的的图片视图序号   imageView：单击操作的图片视图
@property (nonatomic, copy) void (^hiddenBlock) (NSInteger index, UIImageView *imageView);

///长按保存图片
@property (nonatomic, strong) void (^saveImageBlock)(UIImageView *imageView);

/**
 显示子视图
 */
- (void)showSubviews;

/**
 隐藏子视图
 */
- (void)hiddenSubviews;

@end
