//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "HelpCommand.h"
#import "App.h"
#import "ErrorCodes.h"
#import "CommandsCommand.h"

@implementation HelpCommand

- (BOOL)run:(NSArray *)params error:(NSError **)error {
  BOOL success = YES;
  if (params.count == 0) {
    [self showAll];
  } else {
    if (![self show:params[0]]) {
      if (error != NULL) {
        *error = [NSError errorWithDomain:[[App app] errorDomain]
                                     code:ErrorCodeBadInput
                                 userInfo:@{
                                   NSLocalizedDescriptionKey :
                                   [NSString stringWithFormat:@"%@ is not a valid command", params[0]]
                                 }];
      }
      success = NO;
    }
  }
  return success;
}

- (NSString *)usage {
  return @"[command]";
}

- (NSString *)help {
  return @"Displays help. If you specify a command, displays help for that command.\n"
    @"Otherwise, displays a help summary.";
}

- (NSString *)summary {
  return @"Display help";
}

- (void)showAll {
  App *app = [App app];
  [app out:[NSString stringWithFormat:@"Usage: hc <command> [<args>]"]];
  [app out:@""];
  [app out:@"Commands:"];

  CommandsCommand *commandsCommand = [[CommandsCommand alloc] init];
  [commandsCommand run:nil error:nil];
}

- (BOOL)show:(NSString *)command {
  return YES;
}

@end