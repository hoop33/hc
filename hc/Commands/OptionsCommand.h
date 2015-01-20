//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@protocol Option;

@interface OptionsCommand : NSObject <Command>

- (NSString *)textForOption:(id <Option>)option showFull:(BOOL)showFull;

@end
