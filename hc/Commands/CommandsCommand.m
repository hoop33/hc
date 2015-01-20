//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "CommandsCommand.h"
#import "Utils.h"
#import "Response.h"

@implementation CommandsCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  // Suppress unused parameter warnings
  (void)params;
  (void)error;
  
  NSMutableString *message = [[NSMutableString alloc] init];
  for (Class cls in [Utils allCommands]) {
    id <Command> command = [[cls alloc] init];
    [message appendString:[self textForCommand:command showFull:NO]];
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

- (NSString *)description {
  return @"List available commands";
}

- (NSString *)textForCommand:(id <Command>)command showFull:(BOOL)showFull {
  NSMutableString *text = [NSMutableString string];
  NSString *name = [Utils nameForCommand:command];
  [text appendFormat:@"   %-12s%@\n",
                        [name UTF8String],
                        [command description]];
  if (showFull) {
    [text appendFormat:@"   usage:      hc %@ %@\n", name, [command usage]];
    [text appendFormat:@"\n   %@\n", [command help]];
  }
  return text;
}

@end
