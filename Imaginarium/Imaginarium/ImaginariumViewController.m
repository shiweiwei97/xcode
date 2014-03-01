//
//  ImaginariumViewController.m
//  Imaginarium
//
//  Created by Weiwei Shi on 3/1/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "ImaginariumViewController.h"

@interface ImaginariumViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImaginariumViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
