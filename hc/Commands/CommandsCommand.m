//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "CommandsCommand.h"
#import "Utils.h"
#import "Response.h"

@implementation CommandsCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  NSMutableString *message = [[NSMutableString alloc] init];
  for (Class cls in [Utils allCommands]) {
    id <Command> command = [[cls alloc] init];
    [message appendFormat:@"%-12s%@\n",
                          [[Utils nameForCommand:command] UTF8String],
                          [command summary]];
  }
  Response *response = [[Response alloc] init];
  response.message = message;
  return response;
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