//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Command;
@protocol Output;
@protocol Option;

@interface Utils : NSObject

+ (NSArray *)allCommands;
+ (NSArray *)allOutputs;
+ (NSArray *)allOptions;

+ (NSString *)nameForCommand:(id <Command>)command;
+ (id)commandInstanceForName:(NSString *)name;

+ (NSString *)nameForOutput:(id <Output>)output;
+ (id)outputInstanceForName:(NSString *)name;

+ (NSString *)nameForOption:(id <Option>)option;
+ (id)optionInstanceForName:(NSString *)name;
+ (id)optionInstanceForShortName:(NSString *)name;
+ (id)optionInstanceForNameOrShortName:(NSString *)name;

@end