//
//  ViewSamplesViewController.m
//  ViewSamples
//
//  Created by Weiwei Shi on 2/16/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "ViewSamplesViewController.h"

@interface ViewSamplesViewController ()

@end

@implementation ViewSamplesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect labelRect = CGRectMake(20, 20, 200, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.text = @"Hello World!";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
