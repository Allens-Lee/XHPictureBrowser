//
//  XHPictureBannerView.m
//  XHPictureBrowser_Demo
//
//  Created by 李鑫浩 on 2017/9/12.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "XHPictureBannerView.h"
#import "XHPictureBannerCell.h"

NSString *const cell_identify = @"PictureBanner";       ///单元格识别符

@interface XHPictureBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *_imageUrls;                         ///图片链接数组
    NSInteger _itemCount;                               ///总项数
    NSTimer *_timer;                                     ///计时器
}

@property (nonatomic, strong) UICollectionView *collectionView;                 ///用于滑动显示

@end

@implementation XHPictureBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageUrls = [NSMutableArray array];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark -- Create Subviews method
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[XHPictureBannerCell class] forCellWithReuseIdentifier:cell_identify];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 37, self.frame.size.width, 37)];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];

    }
    return _pageControl;
}

#pragma mark -- Public method 
- (void)setImageUrls:(NSArray *)imageUrls
{
    _itemCount = imageUrls.count;
    [_imageUrls removeAllObjects];
    if (imageUrls.count > 1)
    {
        [_imageUrls addObject:@[[imageUrls lastObject]]];
        [_imageUrls addObject:imageUrls];
        [_imageUrls addObject:@[[imageUrls firstObject]]];
        
        self.pageControl.numberOfPages = _itemCount;
        [self createTimer];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else if (imageUrls.count > 0)
    {
        [_imageUrls addObject:imageUrls];
        self.pageControl.hidden = YES;
        [self.collectionView reloadData];
    }
    else
    {
        [self.collectionView reloadData];
    }
}

#pragma mark -- Private method
- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                              target:self
                                            selector:@selector(autoScrollToNextPage)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)releaseTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- Target method
-(void)autoScrollToNextPage
{
    NSInteger index = roundf(_collectionView.contentOffset.x / _collectionView.frame.size.width);
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:1];
    if (index >= _itemCount)
    {
        indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _imageUrls.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_imageUrls[section]).count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XHPictureBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_identify forIndexPath:indexPath];
    [cell setWithImageUrl:_imageUrls[indexPath.section][indexPath.row] withPlaceholderImage:self.placeholderImage];
    return cell;
}

#pragma mark -- UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger index = roundf(collectionView.contentOffset.x / collectionView.frame.size.width);
    if (index == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemCount - 1 inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (index == _itemCount + 1) {
       [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else {
        self.pageControl.currentPage = index - 1;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !self.didSelectedCallBack ?: self.didSelectedCallBack(indexPath.item);
}

#pragma mark -- UIScrollViewDelegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self releaseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self createTimer];
}

@end
