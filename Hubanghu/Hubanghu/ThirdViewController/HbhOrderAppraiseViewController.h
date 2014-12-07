//
//  OrderAppraiseViewController.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
#import "HbhOrderModel.h"

@interface HbhOrderAppraiseViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *skillLabel;

- (instancetype)initWithModel:(HbhOrderModel *)aModel;
@end
