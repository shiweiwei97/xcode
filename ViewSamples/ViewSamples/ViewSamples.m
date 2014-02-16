//
//  ViewSamples.m
//  ViewSamples
//
//  Created by Weiwei Shi on 2/16/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "ViewSamples.h"

@implementation ViewSamples

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 75, 10);
    CGContextAddLineToPoint(context, 160, 150);
    
    [[UIColor redColor] set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [self setNeedsDisplay];
}

@end
