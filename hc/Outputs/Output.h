//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Response;

@protocol Output <NSObject>

- (void)output:(Response *)response;
- (NSString *)help;

@end