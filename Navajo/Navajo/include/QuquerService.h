//
//  QuquerService.h
//  QuquerSDK
//
//  Created by wuyifan on 13-3-8.
//  Copyright (c) 2013年 139ME. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuquerDelegate <NSObject>

- (void)didSendDataToken;
- (void)didReceiveDataToken:(NSString*)dataToken;

@end

@interface QuquerService : NSObject

+ (QuquerService*)defaultService;

- (void)setDelegate:(id<QuquerDelegate>)delegate;

- (void)start;
- (void)stop;
- (BOOL)sendDataToken:(NSString*)dataToken;
- (short*)getWaveData:(short*)size;

@end
