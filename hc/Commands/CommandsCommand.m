//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "CommandsCommand.h"
#import "Utils.h"
#import "App.h"


@implementation CommandsCommand

- (BOOL)run:(NSArray *)params error:(NSError **)error {
  App *app = [App app];
  for (Class cls in [Utils allCommands]) {
    id <Command> command = [[cls alloc] init];
    [app out:[NSString stringWithFormat:@"   %-12s%@",
                                        [[Utils nameForCommand:command] UTF8String],
                                        [command summary]]];
  }
  return YES;
}

- (NSString *)usage {
  return @"";
}

- (NSString *)help {
  return @"Lists all available commands.";
}

- (NSString *)summary {
  return @"List available commands";
}

@end