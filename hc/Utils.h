//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface Utils : NSObject

+ (NSArray *)allCommands;
+ (NSString *)nameForCommand:(id <Command>)command;
+ (id)commandInstanceForName:(NSString *)name;

@end