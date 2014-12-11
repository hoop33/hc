//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandLine : NSObject

@property (nonatomic, strong) NSArray *params;
@property (nonatomic, copy) NSString *commandName;
@property (nonatomic, copy) NSString *outputName;

- (BOOL)parseParameters:(NSMutableArray *)array error:(NSError **)error;
- (int)run;

@end