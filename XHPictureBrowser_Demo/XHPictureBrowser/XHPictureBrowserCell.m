//
//  XHPictureBrowserCell.m
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "XHPictureBrowserCell.h"
#import "XHLoadingView.h"
#import "UIImageView+WebCache.h"

@interface XHPictureBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, strong) XHLoadingView *loadingView;                    ///加载视图
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;             ///双击
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;             ///单击
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;       ///长按
@property (nonatomic, strong) NSURL *imageUrl;                               ///图片链接
@property (nonatomic, strong) UIImage *placeHolderImage;                     ///图片缩略图
@property (nonatomic, strong) UIButton *reloadButton;                        ///重新加载
@property (nonatomic, assign) BOOL hasLoadedImage;                           ///是否已经加载完图片

@end

@implementation XHPictureBrowserCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.scrollview];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.longPress];
    }
    return self;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview)
    {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview
{
    if (!_imageview)
    {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap)
    {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap)
    {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress)
    {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    }
    return _longPress;
}

#pragma mark -- Public method
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    _imageUrl = [NSURL URLWithString:url];
    _placeHolderImage = placeholder;
    
    if (![url hasPrefix:@"http"] || url.length <= 0)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:url];
        if (image == nil)
        {
            _imageview.image = _placeHolderImage;
        }
        else
        {
            _imageview.image = image;
        }
        self.hasLoadedImage = YES;
        [self setNeedsLayout];
    }
    else
    {
        [self reloadImage];
    }
}

- (void)reloadImage
{
    [_reloadButton removeFromSuperview];
    [self.loadingView removeFromSuperview];
    
    //添加进度指示器
    XHLoadingView *loadingView = [[XHLoadingView alloc] init];
    loadingView.type = XHLoadingViewTypeLoopDiagram;
    loadingView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.loadingView = loadingView;
    [self addSubview:loadingView];
    
    __weak __typeof(self)weakSelf = self;
    [_imageview sd_setImageWithURL:_imageUrl placeholderImage:_placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.loadingView.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.loadingView removeFromSuperview];
        if (error && strongSelf.imageUrl)
        {
            //图片加载失败的处理，此处可以自定义各种操作（...）
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200, 40);
            button.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
            [button setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            strongSelf.reloadButton = button;
        }
        else
        {
            //图片加载成功
            strongSelf.hasLoadedImage = YES;
            [strongSelf setNeedsLayout];
        }
    }];
}

#pragma mark -- Target method
///双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    //图片加载完之后才能响应双击放大
    if (!self.hasLoadedImage)
    {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0)
    {
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    }
    else
    {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

///单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    !self.singleTapBlock ?: self.singleTapBlock(self);
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    //图片加载完之后才能响应长按保存
    if (!self.hasLoadedImage)
    {
        return;
    }
    !self.longPressBlock ?: self.longPressBlock(self.imageview);
}

#pragma mark -- System method
- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _loadingView.center = _scrollview.center;
    [self adjustFrame];
}

#pragma mark -- Private method
- (void)adjustFrame
{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {//图片宽度始终==屏幕宽度(新浪微博就是这种效果)
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                //竖屏时候
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{ //横屏的时候
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        //初始化
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        //重置内容大小
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView //这里是缩放进行时调整
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
    
}

@end
