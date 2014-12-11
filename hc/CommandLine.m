//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "CommandLine.h"
#import "Command.h"
#import "ErrorCodes.h"
#import "App.h"
#import "Utils.h"
#import "Response.h"
#import "Output.h"
#import "Option.h"
#import "OutputOption.h"

@interface CommandLine ()
@property(nonatomic, strong) NSArray *params;
@property(nonatomic, copy) NSString *commandName;
@property(nonatomic, strong) NSMutableDictionary *options;
@end

@implementation CommandLine

- (BOOL)parseParameters:(NSMutableArray *)params error:(NSError **)error {
  _options = [NSMutableDictionary dictionary];
  NSMutableArray *args = [NSMutableArray array];
  NSString *errorMessage = nil;

  for (NSUInteger i = 0, n = params.count; i < n; i++) {
    NSString *param = params[i];
    if ([param hasPrefix:@"-"]) {
      NSString *paramName = [param stringByReplacingOccurrencesOfString:@"-" withString:@""];
      id <Option> option = [Utils optionInstanceForNameOrShortName:paramName];
      if (option == nil) {
        errorMessage = [NSString stringWithFormat:@"Unknown option: '%@'", param];
        break;
      } else {
        i += [option numberOfParameters];
        if (i >= n) {
          errorMessage = [NSString stringWithFormat:@"Missing parameter for %@", param];
          break;
        } else {
          _options[[[option class] className]] = params[i];
        }
      }
    } else if (_commandName == nil) {
      _commandName = param;
    } else {
      [args addObject:param];
    }
  }

  if (errorMessage != nil) {
    [[App app] out:errorMessage];
    return NO;
  } else {
    _params = [NSArray arrayWithArray:args];
    if (_commandName == nil) {
      _commandName = @"help";
    }
    return YES;
  }
}

- (int)run {
  int returnCode = ErrorCodeSuccess;
  App *app = [App app];
  id <Command> command = [Utils commandInstanceForName:_commandName];

  NSString *outputName = _options[[OutputOption className]];
  if (outputName == nil) {
    outputName = @"text";
  }

  id <Output> output = [Utils outputInstanceForName:outputName];
  if (command == nil) {
    [app out:[NSString stringWithFormat:@"'%@' is not a valid command. See 'hc help'.",
                                        _commandName]];
    returnCode = ErrorCodeBadInput;
  } else if (output == nil) {
    [app out:[NSString stringWithFormat:@"'%@' is not a valid output. See 'hc help'.",
                                        outputName]];
    returnCode = ErrorCodeBadInput;
  } else {
    NSError *error;
    Response *response = [command run:_params error:&error];
    if (response == nil) {
      if (error != NULL) {
        [app out:error.localizedDescription];
        returnCode = (int) error.code;
      } else {
        returnCode = ErrorCodeUnknown;
      }
    } else {
      [output output:response];
    }
  }
  return returnCode;
}

@end