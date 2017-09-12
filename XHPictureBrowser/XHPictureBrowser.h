//
//  XHPictureBrowserController.h
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHPictureBrowser : UIViewController

///点中的图片视图
@property (nonatomic, strong) UIImageView *touchImgView;

///点中的图片视图(touchImgView)在图片视图数组(imageViews)中的下标(必须一致)
///当touchImageView或imageViews为空时，或者imageViews的count小于imageUrls的count时，会根据此参数确定默认选中的图片视图
@property (nonatomic, assign) NSInteger touchIndex;

///图片视图数组
///当imageViews的count大于imageUrls的count时，从index=0开始
///当imageViews的count小于imageUrls的count且touchImgView包含在imageViews图片视图数组中时，会根据touchImgView对应的touchIndex确定index的对应起始值
@property (nonatomic, strong) NSArray *imageViews;

///图片链接数组(包括网络url和本地url)
///始终从index=0开始
@property (nonatomic, strong) NSArray *imageUrls;

/**
 以model方式显示

 @param viewController 调用显示的控制器
 */
- (void)showIn:(UIViewController *)viewController;

/**
 以push方式显示

 @param viewController 调用显示的控制器
 */
- (void)showPushBy:(UIViewController *)viewController;

@end
