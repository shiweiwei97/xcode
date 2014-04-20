//
//  YCScanContactViewController.h
//  YContacts
//
//  Created by Weiwei Shi on 4/20/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YCScanContactViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@end
