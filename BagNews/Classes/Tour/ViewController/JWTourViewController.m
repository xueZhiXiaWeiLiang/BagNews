//
//  JWTourViewController.m
//  BagNews
//
//  Created by 微凉 on 16/4/13.
//  Copyright © 2016年 微凉. All rights reserved.
//

#import "JWTourViewController.h"
#import "JWTourViewModel.h"
#import "JWCarouselFigureView.h"
#import "JWTourCustomModel.h"
#import "JWTourBigCell.h"
#import "JWTourNearMainViewController.h"
#define kWIDTH 240 * self.view.width / SCREENWIDTH
#define URL @"http://api.breadtrip.com/v2/index/"
#define DURL @"http://web.breadtrip.com/"
#define MORE @"http://api.breadtrip.com/v2/index/?lat=38.88256814493554&lng=121.5395097188763&next_start="
@interface JWTourViewController ()
@property(retain,nonatomic)UIButton *nearBy;
@end

@implementation JWTourViewController
// lazyLoading
- (NSArray *)locations
{
    if (!_locations) {
        _locations = [NSArray array];
    }
    
    return _locations;
}
- (NSArray *)models
{
    if (!_models) {
        _models = [NSArray array];
    }
    
    return _models;
}
- (UIButton *)nearBy
{
    if (!_nearBy) {
        _nearBy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _nearBy.tag = 2000;
        [_nearBy addTarget:self action:@selector(transAnotherViewController:) forControlEvents:1<<6];
        [_nearBy setImage:[UIImage imageNamed:@"dingwei"] forState:0];
        [_nearBy setImage:[UIImage imageNamed:@"dingwei"] forState:1<<0];
    }
    return _nearBy;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nearBy];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JWTourBigCell" bundle:nil] forCellReuseIdentifier:@"JWTourBigCell"];
    self.tableView.rowHeight = 230;
    
    [self setRefreshMethod];
    
}
// 刷新关联
- (void)setRefreshMethod
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [JWTourViewModel getNewsData:URL ViewController:self TableView:self.tableView];
        
    }];
    [self.tableView.mj_header beginRefreshing];
#pragma mark - 下拉加载的实现
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [JWTourViewModel getMoreData:[NSString stringWithFormat:@"%@%@",MORE,self.next_start] ViewController:self TableView:self.tableView DataArr:(NSMutableArray *)self.models];
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JWCarouselFigureView *)carouseView
{
    if (!_carouseView) {
        _carouseView = [[JWCarouselFigureView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kWIDTH)];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            JWTourCustomModel *model = [self.models objectAtIndex:i];
            if(model.image_url){
                [temp addObject:model.image_url];
            }
        }
        _carouseView.color = [UIColor orangeColor];
        _carouseView.pics = temp;
        WEAK(ws);
#pragma - mark 轮播图点击回调block
        _carouseView.CallBack = ^(NSInteger index)
        {
            __strong typeof(ws)StrongSelf = ws;
            JWTourCustomModel *model = [StrongSelf.models objectAtIndex:index];
#pragma - mark 获取数据交给VM处理跳转
            [JWTourViewModel selectedCellTableView:nil IndexPath:nil ViewController:StrongSelf Link:model.html_url];
            
            
        };
    }
    
    
    return _carouseView;
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count - 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWTourCustomModel *model = self.models[indexPath.row + 16];
    JWTourBigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWTourBigCell"];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWTourCustomModel *model = self.models[indexPath.row + 16];
    [JWTourViewModel selectedCellTableView:tableView IndexPath:indexPath ViewController:self Link:[NSString stringWithFormat:@"%@%@",DURL,model.share_url]];
}
// 导航左右按钮
- (void)transAnotherViewController:(UIButton *)sender
{
    switch (sender.tag) {
        case 2000:
            [self.navigationController pushViewController:[JWTourNearMainViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}
@end
