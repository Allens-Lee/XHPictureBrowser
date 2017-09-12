//
//  XHPictureBrowserController.m
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "XHPictureBrowser.h"
#import "XHPictureBrowserView.h"

CGFloat const transitions_duration = 0.35f;                 ///转场的动画时长

@interface XHPictureBrowser ()
{
    XHPictureBrowserView *_pictureBrowserView;
    BOOL _showWithPushType;                                 ///是否是以push的方式显示页面的
    NSInteger _statusBarChangeNum;                          ///状态栏状态切换次数
}

@property (nonatomic, strong) UIView *navigationBar;        ///导航条
@property (nonatomic, strong) UILabel *navigationTitle;     ///导航标题

@end

@implementation XHPictureBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createSubviews];
    [self initializeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_showWithPushType) {
            [_pictureBrowserView showSubviews];
            [self.view addSubview:self.navigationBar];
        } else {
            if (self.imageViews.count > 0 || self.touchImgView) {
                [self showTouchImageView];
            } else {
                [_pictureBrowserView showSubviews];
            }
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return _statusBarChangeNum % 2;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return (!_statusBarChangeNum % 2 || _statusBarChangeNum == 0) ? UIStatusBarAnimationFade : UIStatusBarAnimationSlide;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Create subviews method
- (UIView *)navigationBar
{
    if (!_navigationBar)
    {
        _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _navigationBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_navigationBar];
        
        UIButton *backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
        [backItem setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [backItem addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [backItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 17, 0, 0)];
        [_navigationBar addSubview:backItem];
        
        _navigationTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        _navigationTitle.textColor = [UIColor whiteColor];
        _navigationTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        [_navigationBar addSubview:_navigationTitle];
    }
    return _navigationBar;
}

- (void)createSubviews
{
    _pictureBrowserView = [[XHPictureBrowserView alloc]initWithFrame:self.view.bounds];
    _pictureBrowserView.backgroundColor = [UIColor blackColor];
    _pictureBrowserView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    _pictureBrowserView.hiddenBlock = ^(NSInteger index, UIImageView *imageView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hiddenWithIndex:index andImageView:imageView];
    };
    _pictureBrowserView.saveImageBlock = ^(UIImageView *imageView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saveImageWithImageView:imageView];
    };
    [self.view insertSubview:_pictureBrowserView atIndex:0];
}

#pragma mark -- Private method
- (void)initializeView
{
    NSInteger itemCount = MAX(_imageViews.count, _imageUrls.count) > 0 ? MAX(_imageViews.count, _imageUrls.count) : 1;
    if (!self.touchImgView || self.imageViews.count < itemCount) {
        self.touchIndex = self.touchIndex < itemCount ? self.touchIndex : 0;
    } else {
        self.touchIndex = [self.imageViews indexOfObject:self.touchImgView];
    }
    if (self.imageViews.count == itemCount) {
        self.touchImgView = self.imageViews[self.touchIndex];
    }
     _pictureBrowserView.itemCount = itemCount;
    _pictureBrowserView.touchIndex = self.touchIndex;
    _pictureBrowserView.touchImageView = self.touchImgView;
    _pictureBrowserView.imageViews = self.imageViews;
    _pictureBrowserView.imageUrls = self.imageUrls;
}

- (void)showTouchImageView
{
    if (!self.touchImgView) return;
    CGRect rect = [self.touchImgView.superview convertRect:self.touchImgView.frame toView:self.view];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.frame = rect;
    tempView.image = self.touchImgView.image;
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tempView];
    
    CGRect newRect;
    CGFloat imageSizeW = tempView.image.size.width;
    CGFloat imageSizeH = tempView.image.size.height;
    CGFloat newHeight = (imageSizeH * kScreenWidth)/imageSizeW;
    if (newHeight <= kScreenHeight) {
        newRect = CGRectMake(0, (kScreenHeight - newHeight) * 0.5 , kScreenWidth, newHeight);
    } else {
        newRect = CGRectMake(0, 0, kScreenWidth, newHeight);
    }
    
    [UIView animateWithDuration:transitions_duration animations:^{
        tempView.frame = newRect;
        _pictureBrowserView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        [_pictureBrowserView showSubviews];
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;//隐藏状态栏
    }];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Block method
- (void)hiddenWithIndex:(NSInteger)index andImageView:(UIImageView *)imageView
{
    if (_showWithPushType)
    {
        ///以push方式显示页面的 单击可以隐藏状态栏
        ++ _statusBarChangeNum;
        [UIView animateWithDuration:.3 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            if (_statusBarChangeNum % 2) {
                self.navigationBar.transform = CGAffineTransformTranslate(self.view.transform, 0, -20);
                self.navigationBar.alpha = 0.0f;
            } else {
                self.navigationBar.transform = CGAffineTransformIdentity;
                self.navigationBar.alpha = 1.0f;
            }
        }];
    }
    else
    {
        UIImageView *originalView = nil;
        if (index == _pictureBrowserView.touchIndex)
        {
            originalView = self.touchImgView;
        }
        else if (self.imageViews)
        {
            if ([self.imageViews containsObject:self.touchImgView])
            {
                NSInteger newIndex = [self.imageViews indexOfObject:self.touchImgView];
                newIndex = index - (self.touchIndex - newIndex);
                if (index >= 0)
                {
                    originalView = newIndex < self.imageViews.count ? self.imageViews[newIndex] : nil;
                }
            }
            else
            {
                originalView = index < self.imageViews.count ? self.imageViews[index] : nil;
            }
        }
        
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.frame = [imageView.superview convertRect:imageView.frame toView:self.view];
        tempView.image = imageView.image;
        tempView.contentMode = originalView.contentMode;
        tempView.clipsToBounds = YES;
        [self.view addSubview:tempView];
        
        [_pictureBrowserView hiddenSubviews];
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;//显示状态栏
        [UIView animateWithDuration:transitions_duration animations:^{
            CGRect originalRect = [self.view convertRect:originalView.frame fromView:originalView.superview];
            if (!originalView || !CGRectIntersectsRect(originalRect, self.view.frame))
            {
                tempView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                tempView.alpha = 0.0f;
            }
            else
            {
                tempView.frame = originalRect;
            }
            _pictureBrowserView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

- (void)saveImageWithImageView:(UIImageView *)imageView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertController *alert;
    if (error) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
        alert = [UIAlertController alertControllerWithTitle:@"保存图片被阻止了" message:[NSString stringWithFormat:@"请到系统->“设置”->“隐私”->“照片”中开启“%@”访问权限",appName] preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alert = [UIAlertController alertControllerWithTitle:nil message:@"已保存至照片库" preferredStyle:UIAlertControllerStyleAlert];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- Public method
- (void)showIn:(UIViewController *)viewController
{
    if (self.touchImgView || self.imageUrls.count > 0 || self.imageViews.count > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor clearColor];
            self.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [viewController presentViewController:self animated:NO completion:^{
                
            }];
        });
    }
}

- (void)showPushBy:(UIViewController *)viewController
{
    if (self.touchImgView || self.imageUrls.count > 0 || self.imageViews.count > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor blackColor];
            _showWithPushType = YES;
            [viewController.navigationController pushViewController:self animated:YES];
        });
    }
}

@end
