//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Color;

@interface Response : NSObject

@property (readonly, nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, copy) NSString *message;

- (void)add:(Color *)color;

@end
