//
//  DrPillWebsiteViewController.m
//  Psychologist
//
//  Created by Weiwei Shi on 3/1/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "DrPillWebsiteViewController.h"

@interface DrPillWebsiteViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation DrPillWebsiteViewController

@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
