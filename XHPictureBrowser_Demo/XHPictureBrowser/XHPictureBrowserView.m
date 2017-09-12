//
//  XHPictureBrowserView.m
//  ptoto
//
//  Created by 李鑫浩 on 2017/9/6.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "XHPictureBrowserView.h"

NSInteger const margin = 20;                        ///图片之间的间距
NSString *const identify = @"PictureBrowser";       ///单元格识别符

@interface XHPictureBrowserView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;           ///流式布局
@property (nonatomic, strong) UICollectionView *collectionView;                 ///用于滑动显示
@property (nonatomic, strong) UILabel *indexFlag;                               ///序号

@end

@implementation XHPictureBrowserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.collectionView];
        [self addSubview:self.indexFlag];
    }
    return self;
}

#pragma mark -- Create Subviews method
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(self.frame.size.width + margin, self.frame.size.height);
        _flowLayout.minimumLineSpacing = 0.0f;
        _flowLayout.minimumInteritemSpacing = 0.0f;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width + margin, self.frame.size.height) collectionViewLayout:_flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[XHPictureBrowserCell class] forCellWithReuseIdentifier:identify];
        _collectionView.hidden = YES;
    }
    return _collectionView;
}

- (UILabel *)indexFlag
{
    if (!_indexFlag)
    {
        _indexFlag = [[UILabel alloc]init];
        _indexFlag.frame = CGRectMake(0, 0, self.frame.size.width, 15);
        _indexFlag.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height - 45);
        _indexFlag.font = [UIFont systemFontOfSize:13];
        _indexFlag.textColor = [UIColor whiteColor];
        _indexFlag.textAlignment = NSTextAlignmentCenter;
        _indexFlag.hidden = YES;
    }
    return _indexFlag;
}

#pragma mark -- Public method
- (void)showSubviews
{
    self.alpha = 1.0f;
    self.collectionView.hidden = NO;
    self.indexFlag.hidden = NO;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.touchIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    _indexFlag.text = [NSString stringWithFormat:@"%li/%li",_touchIndex + 1, _itemCount];
}

- (void)hiddenSubviews
{
    self.collectionView.hidden = YES;
    self.indexFlag.hidden = YES;
}

#pragma mark -- Block method
- (void)hiddenWithCell:(XHPictureBrowserCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    !self.hiddenBlock ?: self.hiddenBlock(indexPath.item, cell.imageview);
}

- (void)saveImageWithImageView:(UIImageView *)imageView
{
    !self.saveImageBlock ?: self.saveImageBlock(imageView);
}

#pragma mark -- Private method
- (UIImage *)imageWithIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = nil;
    if ([self.imageViews containsObject:self.touchImageView])
    {
        NSInteger index = [self.imageViews indexOfObject:self.touchImageView];
        index = indexPath.item - (self.touchIndex - index);
        if (index >= 0)
        {
            imageView = self.imageViews.count > index ? self.imageViews[index] : nil;
        }
    }
    else
    {
        imageView = self.imageViews.count > indexPath.item ? self.imageViews[indexPath.item] : nil;
    }
    UIImage *image = imageView.image;
    if (!image && indexPath.item == self.touchIndex && self.touchImageView){
        image = self.touchImageView.image;
    }
    return image;
}

- (NSString *)imageUrlWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageUrl = self.imageUrls.count > indexPath.item ? self.imageUrls[indexPath.item] : nil;
    return imageUrl;
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XHPictureBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setImageWithURL:[self imageUrlWithIndexPath:indexPath] placeholderImage:[self imageWithIndexPath:indexPath]];
    __weak typeof(self) weakSelf = self;
    cell.singleTapBlock = ^(XHPictureBrowserCell *cell) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hiddenWithCell:cell];
    };
    cell.longPressBlock = ^(UIImageView *imageView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saveImageWithImageView:imageView];
    };
    return cell;
}

#pragma mark -- UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexFlag.text = [NSString stringWithFormat:@"%.0f/%li",roundf(collectionView.contentOffset.x / collectionView.frame.size.width) + 1, _itemCount];
    ((XHPictureBrowserCell *)cell).scrollview.zoomScale = 1.0f;
}

@end
