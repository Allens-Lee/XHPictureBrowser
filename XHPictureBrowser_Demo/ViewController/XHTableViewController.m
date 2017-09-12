//
//  AFTableViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "XHTableViewController.h"
#import "XHTableViewCell.h"
#import "XHPictureBrowser.h"

@interface XHTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_imageUrls;
}

@end

@implementation XHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageUrls = [NSMutableArray array];
    for (NSInteger i = 0; i < 16; i ++)
    {
        [_imageUrls addObject:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%li",i % 4 + 1] ofType:@"png"]];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 150;
    [_tableView registerClass:[XHTableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.imgView.image = [UIImage imageWithContentsOfFile:_imageUrls[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *indexPaths = [tableView indexPathsForVisibleRows];
    NSMutableArray *imageViews = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths)
    {
        XHTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [imageViews addObject:cell.imgView];
    }
    
    XHTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    XHPictureBrowser *browser = [[XHPictureBrowser alloc]init];
    browser.touchImgView = cell.imgView;
    browser.touchIndex = indexPath.row;
    browser.imageViews = imageViews;
    browser.imageUrls = _imageUrls;
    [browser showIn:self];
}


@end
