//
//  TableViewCell.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "XHTableViewCell.h"

@implementation XHTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake((self.frame.size.width - 100) / 2.0, 0, 100, 150);
}

@end
