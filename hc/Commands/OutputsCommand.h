//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@protocol Output;

@interface OutputsCommand : NSObject <Command>

- (NSString *)textForOutput:(id <Output>)output showFull:(BOOL)showFull;

@end
