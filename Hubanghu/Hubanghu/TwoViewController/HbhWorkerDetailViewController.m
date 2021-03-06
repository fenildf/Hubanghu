//
//  workerDetailViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerDetailViewController.h"
#import "HbhTopTableViewCell.h"
#import "HbhWorkerSecondTopTableViewCell.h"
#import "HbhWorkerCommentTableViewCell.h"
#import "HbhWorkerThirdTopTableViewCell.h"
#import "HbhWorkerImgTableViewCell.h"
#import "HbhWorkerDetailManage.h"
#import "UIImageView+WebCache.h"
#import "HbhMakeAppointMentViewController.h"
#import "HbhCommentViewController.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
//RGBCOLOR(244, 244, 244);
@interface HbhWorkerDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *workDetailTableView;
@property(nonatomic, strong) HbhWorkers *myModel;
@property(nonatomic) int myWorkerId;
@property(nonatomic, strong)HbhWorkerDetailManage *workerDetailManage;

@property(nonatomic, strong) HbhWorkerData *workerData;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation HbhWorkerDetailViewController

- (instancetype)initWithWorkerModel:(HbhWorkers *)aModel
{
    self = [super init];
    self.myModel = aModel;
    self.myWorkerId = aModel.workersIdentifier;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"工人详情";
    [self settitleLabel:@"工人详情"];
    
    self.workDetailTableView = [[UITableView alloc]
                                initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.workDetailTableView.dataSource = self;
    self.workDetailTableView.delegate = self;
    self.workDetailTableView.allowsSelection = NO;
    self.workDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.workDetailTableView.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.view addSubview:self.workDetailTableView];
    
//    [self.view addSubview:self.activityView];
//    [self.activityView startAnimating];
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
    
    [self addTableViewTrag];
    
    [self.workerDetailManage getWorkerDetailWithWorkerId:self.myWorkerId SuccBlock:^(HbhWorkerData *aData) {
        self.workerData = aData;
        [self.workDetailTableView reloadData];
//        [self.activityView stopAnimating];
        [SVProgressHUD dismiss];
    } and:^{
        
    }];
}

#pragma mark 上拉下拉
#pragma mark 增加上拉下拉
- (void)addTableViewTrag
{
    __weak HbhWorkerDetailViewController *weakself = self;
    [weakself.workDetailTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.workDetailTableView.pullToRefreshView stopAnimating];
            [self.workerDetailManage getWorkerDetailWithWorkerId:self.myWorkerId SuccBlock:^(HbhWorkerData *aData) {
                self.workerData = aData;
                [self.workDetailTableView reloadData];
//                [self.activityView stopAnimating];
                [SVProgressHUD dismiss];
            } and:^{
                
            }];
        });
    }];
    
    //    if (btnCount == 15)
    //    {
    //        [weakself.showOrderTableView addInfiniteScrollingWithActionHandler:^{
    //            int64_t delayInSeconds = 2.0;
    //            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //            dispatch_after(popTime, dispatch_get_main_queue(), ^{
    //                [weakself.showOrderTableView.infiniteScrollingView stopAnimating];
    //
    //            });
    //        }];
    //    }
    
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]
                         initWithFrame:CGRectMake(kMainScreenWidth/2-20, kMainScreenHeight/2-20, 40, 40)];
        _activityView.color = [UIColor blackColor];
    }
    return _activityView;
}

- (HbhWorkerDetailManage *)workerDetailManage
{
    if (!_workerDetailManage) {
        _workerDetailManage = [[HbhWorkerDetailManage alloc] init];
    }
    return _workerDetailManage;
}

#pragma mark tableView datasource datadelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    headerView.backgroundColor = RGBCOLOR(240, 240, 240);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 14)];
    footView.backgroundColor = RGBCOLOR(240, 240, 240);
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 216;
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return 35;
        }
        else{
            return 70;
        }
        return 0;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            return 35;
        }
        else{
            return 90;
        }
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 1;
    }
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        if (self.workerData.comment.count>4) {
            return 4;
        }else if(self.workerData.comment.count==0)
        {
            return 2;
        }else if (self.workerData.comment.count<4)
        {
            return 1+self.workerData.comment.count;
        }
    }
    else if(section==2)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        HbhTopTableViewCell *cell = [[HbhTopTableViewCell alloc] init];
        [cell.workerIcon sd_setImageWithURL:[NSURL URLWithString:self.workerData.photoUrl] placeholderImage:[UIImage imageNamed:@"workerIcon"]];
        cell.workerNameLabel.text = self.workerData.name;
        if ([self.workerData.workTypeName isEqualToString:@""]||self.workerData.workTypeName==nil) {
            cell.workerTypeLabel.text = @"";
        }
        else
        {
            cell.workerTypeLabel.text = [NSString stringWithFormat:@"[%@]", self.workerData.workTypeName];
        }
        cell.workerYearLabel.text = self.workerData.workingAge;
        cell.workerMountLabel.text = [NSString stringWithFormat:@"%d单", self.workerData.orderCount];
        cell.personLabel.text = self.workerData.desc;
        cell.successLabel.text = self.workerData.succCaseDesc;
        cell.honorLabel.text = self.workerData.certificationDesc;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.skillStar changeStarCount:self.workerData.satisfaction];
        [cell.stasStar changeStarCount:self.workerData.attitude];
        [cell.appointmentBtn addTarget:self action:@selector(makeAppointment) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            HbhWorkerSecondTopTableViewCell *cell = [[HbhWorkerSecondTopTableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.workerData.comment.count>4) {
                UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 8, 30, 15)];
                moreBtn.backgroundColor = RGBCOLOR(183, 183, 183);
                moreBtn.titleLabel.font = kFont10;
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                [moreBtn addTarget:self action:@selector(moreComment) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:moreBtn];
            }
            return cell;
        }
        else
        {
            if (self.workerData.comment.count == 0)
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"暂无评论";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = kFont14;
                return cell;
            }
            else
            {
                HbhWorkerCommentTableViewCell *cell = [[HbhWorkerCommentTableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row==3)
                {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 1)];
                    lineView.backgroundColor = RGBCOLOR(218, 218, 218);
                    [cell addSubview:lineView];
                }
                NSArray *array = self.workerData.comment;
                HbhWorkerComment *model = [array objectAtIndex:indexPath.row-1];
                [cell.userImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:[UIImage imageNamed:@"workerIcon"]];//workerIcon
                cell.userNameLabel.text = model.username;
                cell.timeLabel.text = [self transformTime:model.time];
                cell.typeLabel.text = model.cate;
                cell.commentLabel.text = model.content;
                cell.workerNameLabel.text = model.worker;
                return cell;
            }
        }
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            HbhWorkerThirdTopTableViewCell *cell = [[HbhWorkerThirdTopTableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSArray *array = self.workerData.caseProperty;
            HbhWorkerImgTableViewCell *cell = [[HbhWorkerImgTableViewCell alloc] initWithImgArray:array];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark 跳转到预约
- (void)makeAppointment
{
    [self.navigationController pushViewController:[[HbhMakeAppointMentViewController alloc] initWithWorkerModel:self.myModel] animated:YES];
}

#pragma mark 跳转到更多评论
- (void)moreComment
{
    [self.navigationController pushViewController:[[HbhCommentViewController alloc] initWithWorkerId:self.myWorkerId] animated:YES];
}

- (NSString *)transformTime:(int)aTime
{
    NSDate *newDate  = [NSDate dateWithTimeIntervalSince1970:aTime];
    MLOG(@"%@", newDate);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *showtimeNew = [formatter1 stringFromDate:newDate];
    return showtimeNew;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end