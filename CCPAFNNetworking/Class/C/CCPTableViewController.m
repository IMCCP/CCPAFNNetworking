//
//  CCPTableViewController.m
//  CCPAFNNetworking
//
//  Created by C CP on 16/9/11.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPTableViewController.h"
#import "CCPDataTableViewCell.h"
#import "MJExtension.h"
#import "MBProgressHUD+ADD.h"
#import "CCPNetworking.h"
#import "CCPModel.h"
#import "MJRefresh.h"
#import "CCPEmojiHeaderView.h"

@interface CCPTableViewController ()

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation CCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 1; i < 23; i ++ ) {
        
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_7_%d",i]]];
    }
    
    self.imageArray = imageArr;
    
    [self EmojiHeaderView];
    
}

- (void)EmojiHeaderView
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    CCPEmojiHeaderView *header = [CCPEmojiHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    __weak UITableView *tableView = self.tableView;
    [CCPNetworking getOrPostWithType:GET WithUrl:@"http://newsapi.sina.cn/?resource=feed&accessToken=&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=3d91d5d90c90486cde48597325cf846b699ceb53&deviceModel=apple-iphone5&from=6053093012&idfa=7CE5628E-577A-4A0E-B9E5-283217ECA1F1&idfv=10E31C9D-59AE-4547-BDEF-5FF3EA045D86&imei=3d91d5d90c90486cde48597325cf846b699ceb53&location=39.998602%2C116.365189&osVersion=9.3.5&resolution=640x1136&token=61903050f1141245bfb85231b58e84fb586743436ceb50af9f7dfe17714ee6f7&ua=apple-iphone5__SinaNews__5.3__iphone__9.3.5&weiboSuid=&weiboUid=&wm=b207&rand=221&urlSign=3c861405dd&behavior=manual&channel=news_pic&lastTimestamp=1473578882&listCount=20&p=1&pullDirection=down&pullTimes=8&replacedFlag=1&s=20" params:nil loadingImageArr:self.imageArray toShowView:self.view.window isFullScreen:YES success:^(id response) {
        
        NSDictionary *dataDict = response[@"data"];
        
        NSArray *feedArray = dataDict[@"feed"];
        
        NSArray *dataArry = [CCPModel mj_objectArrayWithKeyValuesArray:feedArray];
        
        self.dataArray = dataArry;
        
        [tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
        
    } fail:^(NSError *error) {
        
        [tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
        
    } showHUD:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCPDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CCPDataTableViewCell" owner:self options:nil] lastObject];
        
    };
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 250;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];
    
    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [CCPNetworking getOrPostWithType:GET WithUrl:@"http://newsapi.sina.cn/?resource=feed&accessToken=&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=3d91d5d90c90486cde48597325cf846b699ceb53&deviceModel=apple-iphone5&from=6053093012&idfa=7CE5628E-577A-4A0E-B9E5-283217ECA1F1&idfv=10E31C9D-59AE-4547-BDEF-5FF3EA045D86&imei=3d91d5d90c90486cde48597325cf846b699ceb53&location=39.998602%2C116.365189&osVersion=9.3.5&resolution=640x1136&token=61903050f1141245bfb85231b58e84fb586743436ceb50af9f7dfe17714ee6f7&ua=apple-iphone5__SinaNews__5.3__iphone__9.3.5&weiboSuid=&weiboUid=&wm=b207&rand=221&urlSign=3c861405dd&behavior=manual&channel=news_pic&lastTimestamp=1473578882&listCount=20&p=1&pullDirection=down&pullTimes=8&replacedFlag=1&s=20" params:nil animationType:AnimationTypeNineDots animationTypeColor:[UIColor yellowColor] isFullScreen:YES  success:^(id response) {
        NSDictionary *dataDict = response[@"data"];
        NSArray *feedArray = dataDict[@"feed"];
        NSArray *dataArry = [CCPModel mj_objectArrayWithKeyValuesArray:feedArray];
        self.dataArray = dataArry;
        [tableView reloadData];
    } fail:^(NSError *error) {
        
    } showHUD:YES];
    
    
}



@end
