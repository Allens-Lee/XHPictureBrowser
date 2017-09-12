//
//  AFScrollerViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "XHScrollerViewController.h"
#import "XHPictureBrowser.h"

@interface XHScrollerViewController ()
{
    NSMutableArray *_imageViews;
    UIScrollView *_scrollView;
}

@end

@implementation XHScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setContentSize:CGSizeMake(0, 150 * 21)];
    [self.view addSubview:_scrollView];
    
    _imageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 21; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.frame.size.width - 100) / 2.0f, i * 150 + 20, 100, 150);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li", i % 7 + 1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPictureBrowserWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.tag = 100 + i;
        [_scrollView addSubview:btn];
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
