//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@protocol Output;

@interface Utils : NSObject

+ (NSArray *)allCommands;
+ (NSArray *)allOutputs;

+ (NSString *)nameForCommand:(id <Command>)command;
+ (id)commandInstanceForName:(NSString *)name;

+ (NSString *)nameForOutput:(id <Output>)output;
+ (id)outputInstanceForName:(NSString *)name;

@end