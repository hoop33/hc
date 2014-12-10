//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "CommandLine.h"
#import "Command.h"
#import "ErrorCodes.h"
#import "App.h"
#import "Utils.h"

@implementation CommandLine

- (BOOL)parseParameters:(NSMutableArray *)params error:(NSError **)error {
  NSMutableArray *args = [NSMutableArray array];

  for (NSUInteger i = 0, n = params.count; i < n; i++) {
    NSString *param = params[i];
    if (_commandName == nil) {
      _commandName = param;
    } else {
      [args addObject:param];
    }
  }

  _params = [NSArray arrayWithArray:args];
  if (_commandName == nil) {
    _commandName = @"help";
  }
  return YES;
}

- (int)run {
  int returnCode = ErrorCodeSuccess;
  App *app = [App app];
  id <Command> command = [Utils commandInstanceForName:_commandName];
  if (command == nil) {
    [app out:[NSString stringWithFormat:@"'%@' is not a valid command. See 'hc help'.",
    _commandName]];
    returnCode = ErrorCodeBadInput;
  } else {
    NSError *error;
    if (![command run:_params error:&error]) {
      if (error != NULL) {
        [app out:error.localizedDescription];
        returnCode = (int) error.code;
      } else {
        returnCode = ErrorCodeUnknown;
      }
    }
  }
  return returnCode;
}

@end