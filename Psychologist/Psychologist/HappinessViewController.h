//
//  HappinessViewController.h
//  Happiness
//
//  Created by Weiwei Shi on 2/22/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface HappinessViewController : UIViewController <SplitViewBarButtonItemPresenter>

// 0 is sad; 100 is very happy
@property (nonatomic) int happiness;

@end
