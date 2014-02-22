//
//  FaceView.h
//  Happiness
//
//  Created by Weiwei Shi on 2/22/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;

@protocol FaceViewDataSource

- (float)smileForFaceView:(FaceView *)sender;

@end

@interface FaceView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

- (void) pinch:(UIPinchGestureRecognizer *)gesture;

@end
