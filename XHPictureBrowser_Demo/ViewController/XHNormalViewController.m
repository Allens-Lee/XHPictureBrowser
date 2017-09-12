//
//  AFNormalViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "XHNormalViewController.h"
#import "XHPictureBrowser.h"

@interface XHNormalViewController ()
{
    NSMutableArray *_imageViews;
}

@end

@implementation XHNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageViews = [NSMutableArray array];
    
    
    CGFloat margin = (self.view.frame.size.width - 200) / 3.0f;
    for (NSInteger i = 0; i < 4; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( margin + (margin + 100) * (i / 2), (i % 2) * (150 + 20) + 150, 100, 150);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li", i + 1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPictureBrowserWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [self.view addSubview:btn];
        [_imageViews addObject:btn.imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Target method
- (void)showPictureBrowserWithBtn:(UIButton *)btn
{
    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    browser.touchIndex = btn.tag - 100;
    browser.imageViews = _imageViews;
    [browser showIn:self];
}



@end
