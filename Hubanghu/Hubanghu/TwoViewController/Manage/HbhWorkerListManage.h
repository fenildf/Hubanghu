//
//  HbhWorkerListManage.h
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbhDataModels.h"

@interface HbhWorkerListManage : NSObject

- (void)getWorkerListSuccBlock:(void(^)(HbhData *aData))aSuccBlock andFailBlock:(void(^)(void))aFailBlock;
@end
