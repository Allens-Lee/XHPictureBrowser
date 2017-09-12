//
//  ViewController.m
//  XHPictureBrowser_Demo
//
//  Created by 李鑫浩 on 2017/9/12.
//  Copyright © 2017年 allens. All rights reserved.
//

#import "ViewController.h"
#import "XHNormalViewController.h"
#import "XHScrollerViewController.h"
#import "XHTableViewController.h"
#import "XHUrlViewController.h"

#import "XHPictureBannerView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_cellTitles;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"XHPictureBrowser";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _cellTitles = @[@"普通视图",@"ScrollView视图",@"表视图",@"纯URL"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    [self.view addSubview:_tableView];
    
    XHPictureBannerView *bannerView = [[XHPictureBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 16 * 9)];
    bannerView.imageUrls = @[@"http://f.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f41348a8ca392211f95cad0c85ea6.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600be63e95eed50352ac75cb7ae.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/91529822720e0cf3a2cdbc240e46f21fbe09aa33.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/2f738bd4b31c87019d17540f237f9e2f0608ffb2.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/5d6034a85edf8db118248ebb0d23dd54574e74e3.jpg"];
    bannerView.didSelectedCallBack = ^(NSInteger index) {
        NSLog(@">>>>>>>>>>>>>>>>%li",index);
    };
    _tableView.tableHeaderView = bannerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.textLabel.text = _cellTitles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row)
    {
        case 0:
        {
            XHNormalViewController *vc = [[XHNormalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            XHScrollerViewController *vc = [[XHScrollerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            XHTableViewController *vc = [[XHTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            XHUrlViewController *vc = [[XHUrlViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
