//
//  XHPictureBannerView.h
//  XHPictureBrowser_Demo
//
//  Created by 李鑫浩 on 2017/9/12.
//  Copyright © 2017年 allens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHPictureBannerView : UIView

/**
 显示序号
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 占位图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 点中轮播图单元项的回调，index表示点中的序号
 */
@property (nonatomic, copy) void (^didSelectedCallBack) (NSInteger index);

/**
 设置轮播图图片

 @param imageUrls 轮播图图片链接数组
 */
- (void)setImageUrls:(NSArray *)imageUrls;

@end
