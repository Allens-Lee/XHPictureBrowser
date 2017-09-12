//
//  XHPictureBrowserCell.h
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHPictureBrowserCell;

#define kMinZoomScale 1.0f
#define kMaxZoomScale 3.0f

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

@interface XHPictureBrowserCell : UICollectionViewCell

///主视图
@property (nonatomic,strong) UIScrollView *scrollview;

///图片
@property (nonatomic,strong) UIImageView *imageview;

///是否在加载图片
@property (nonatomic, assign) BOOL beginLoadingImage;

///单击回调
@property (nonatomic, strong) void (^singleTapBlock)(XHPictureBrowserCell *cell);

///长按回调
@property (nonatomic, strong) void (^longPressBlock)(UIImageView *imageView);

/**
 设置图片信息

 @param url 图片链接
 @param placeholder 图片缩略图
 */
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end
