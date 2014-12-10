//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

+ (App *)app;

- (void)out:(NSObject *)message;
- (NSString *)version;
- (NSString *)errorDomain;

@end