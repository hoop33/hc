//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Response;

@protocol Command <NSObject>

- (Response *)run:(NSArray *)params error:(NSError **)error;
- (NSString *)usage;
- (NSString *)help;

@end