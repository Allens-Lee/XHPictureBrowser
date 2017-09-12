//
//  XHPictureBannerCell.h
//  XHPictureBrowser_Demo
//
//  Created by 李鑫浩 on 2017/9/12.
//  Copyright © 2017年 allens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHPictureBannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;       ///图片视图

/**
 设置图片

 @param url 图片链接
 @param placeholderImage 占位图
 */
- (void)setWithImageUrl:(NSString *)url withPlaceholderImage:(UIImage *)placeholderImage;

@end
