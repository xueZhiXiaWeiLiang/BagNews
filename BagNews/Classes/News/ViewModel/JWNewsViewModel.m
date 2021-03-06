//
//  JWNewsViewModel.m
//  BagNews
//
//  Created by 微凉 on 16/4/24.
//  Copyright © 2016年 微凉. All rights reserved.
//

#import "JWNewsViewModel.h"
#import "JWNewsModel.h"
#import "JWWebViewController.h"
#import "JWNewsOneImageCell.h"
#import "JWNewsBigImageCell.h"
#import "JWNewsThreeImagesCell.h"
#import "JWNewsTableViewController.h"
@implementation JWNewsViewModel

+ (void)selectedCellTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath ViewController:(UIViewController *)viewController Link:(NSString *)link
{
    [super selectedCellTableView:tableView IndexPath:indexPath ViewController:viewController Link:link];
    JWWebViewController *web = [[JWWebViewController alloc] init];
    web.url = link;
    [viewController.navigationController pushViewController:web animated:YES];
}

// 下拉刷新
+ (void)getNewsData:(NSString *)url ViewController:(UIViewController *)viewController TableView:(UITableView *)tableView
{
    [super getNewsData:url ViewController:viewController TableView:tableView];
    JWNewsTableViewController *vc = (JWNewsTableViewController *)viewController;
    __block NSMutableArray *dataArr = [NSMutableArray array];
    [JWNetTool getWithURL:url Parameter:nil Progress:nil Success:^(id result) {
        NSDictionary *dic = [result objectForKey:@"data"];
        NSArray *list = [dic objectForKey:@"list"];
        for (NSDictionary *temp in list) {
            JWNewsModel *model = [JWNewsModel modelWithDic:temp];
            [dataArr addObject:model];
        }
        vc.dataArr = dataArr;
        tableView.tableHeaderView = (UIView *)vc.carouseView;
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
    } Failure:^(id result) {

        NSDictionary *dic = [result objectForKey:@"data"];
        NSArray *list = [dic objectForKey:@"list"];
        for (NSDictionary *temp in list) {
            JWNewsModel *model = [JWNewsModel modelWithDic:temp];
            [dataArr addObject:model];
        }
        vc.dataArr = dataArr;
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
        
    } HttpHeader:nil ResponseType:ResponseTypeJSON];
}

#pragma mark - 基于MJ上拉加载
+ (void)getMoreData:(NSString *)url ViewController:(UIViewController *)viewController TableView:(UITableView *)tableView DataArr:(NSMutableArray *)dataArr
{
    [super getMoreData:url ViewController:viewController TableView:tableView DataArr:dataArr];
    static NSInteger index = 1;
    index++;
     JWNewsTableViewController *vc = (JWNewsTableViewController *)viewController;
    NSString *urlTemp = [NSString stringWithFormat:url,index];
    __block NSMutableArray *arr = [NSMutableArray array];

    [JWNetTool getWithURL:urlTemp Parameter:nil Progress:nil Success:^(id result) {
        NSDictionary *dic = [result objectForKey:@"data"];
        NSArray *list = [dic objectForKey:@"list"];
        [arr addObjectsFromArray:dataArr];
        for (NSDictionary *temp in list) {
            JWNewsModel *model = [JWNewsModel modelWithDic:temp];
            [arr addObject:model];
            vc.dataArr = arr;
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:arr.count - 6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView.mj_footer endRefreshing];
    } Failure:^(id result) {

        NSDictionary *dic = [result objectForKey:@"data"];
        NSArray *list = [dic objectForKey:@"list"];
        [arr addObjectsFromArray:dataArr];
        for (NSDictionary *temp in list) {
            JWNewsModel *model = [JWNewsModel modelWithDic:temp];
            [arr addObject:model];
            vc.dataArr = arr;
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:arr.count - 6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView.mj_footer endRefreshing];

        
    } HttpHeader:nil ResponseType:ResponseTypeJSON];

    
    
}
@end
