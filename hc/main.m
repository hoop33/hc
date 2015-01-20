//
//  main.m
//  hc
//
//  Created by Rob Warner on 12/9/14.
//  Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "CommandLine.h"
#import "ErrorCodes.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    App *app = [App app];

    NSMutableArray *params = [NSMutableArray arrayWithCapacity:(NSUInteger) argc];
    for (int i = 1; i < argc; i++) {
      [params addObject:@(argv[i])];
    }

    NSError *error;
    CommandLine *commandLine = [[CommandLine alloc] init];
    if ([commandLine parseParameters:params error:&error]) {
      return [commandLine run];
    } else if (error != NULL) {
      [app out:[error localizedDescription]];
      return (int) error.code;
    } else {
      return ErrorCodeUnknown;
    }
  }
}
