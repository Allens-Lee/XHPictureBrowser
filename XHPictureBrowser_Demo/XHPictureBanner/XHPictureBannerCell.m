//
//  XHPictureBannerCell.m
//  XHPictureBrowser_Demo
//
//  Created by 李鑫浩 on 2017/9/12.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "XHPictureBannerCell.h"
#import "UIImageView+WebCache.h"

@implementation XHPictureBannerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark -- Public method
- (void)setWithImageUrl:(NSString *)url withPlaceholderImage:(UIImage *)placeholderImage
{
    if (![url hasPrefix:@"http"] || url.length <= 0)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:url];
        if (image == nil)
        {
            self.imageView.image = placeholderImage;
        }
        else
        {
            self.imageView.image = image;
        }
    }
    else
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
    }
}

@end
