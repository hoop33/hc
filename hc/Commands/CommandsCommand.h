//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface CommandsCommand : NSObject<Command>

- (NSString *)textForCommand:(id <Command>)command showFull:(BOOL)showFull;

@end