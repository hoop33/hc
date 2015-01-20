//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "HelpCommand.h"
#import "App.h"
#import "ErrorCodes.h"
#import "CommandsCommand.h"
#import "Response.h"
#import "OutputsCommand.h"
#import "OptionsCommand.h"
#import "Output.h"
#import "Option.h"
#import "Utils.h"

@implementation HelpCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 0) {
    response = [[Response alloc] init];
    response.message = [self showAll];
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
    }
  }
  return response;
}

- (NSString *)usage {
  return @"[command | output | option]";
}

- (NSString *)help {
  return @"Displays help. If you specify a command, displays help for that command.\n"
    @"If you specify an output, displays help for that output.\n"
    @"If you specify an option, displays help for that option.\n"
    @"Otherwise, displays a help summary.";
}

- (NSString *)description {
  return @"Display help";
}

- (NSString *)showAll {
  NSMutableString *message = [NSMutableString string];
  [message appendString:@"Usage: hc <command> [<args>]\n"];
  [message appendString:@"\n"];

  [message appendString:@"Commands:\n"];
  CommandsCommand *commandsCommand = [[CommandsCommand alloc] init];
  Response *commandsResponse = [commandsCommand run:nil error:nil];
  [message appendString:commandsResponse.message];

  [message appendString:@"\n"];
  [message appendString:@"Outputs:\n"];
  OutputsCommand *outputsCommand = [[OutputsCommand alloc] init];
  Response *outputsResponse = [outputsCommand run:nil error:nil];
  [message appendString:outputsResponse.message];

  [message appendString:@"\n"];
  [message appendString:@"Options:\n"];
  OptionsCommand *optionsCommand = [[OptionsCommand alloc] init];
  Response *optionsResponse = [optionsCommand run:nil error:nil];
  [message appendString:optionsResponse.message];
  return message;
}

- (BOOL)show:(NSString *)param {
  return [self showHelpForInstance:[Utils commandInstanceForName:param] name:param] |
    [self showHelpForInstance:[Utils optionInstanceForName:param] name:param] |
    [self showHelpForInstance:[Utils outputInstanceForName:param] name:param];
}

- (BOOL)showHelpForInstance:(id)instance name:(NSString *)name {
  if (instance == nil) return NO;

  App *app = [App app];
  if ([instance conformsToProtocol:@protocol(Command)]) {
    // Commands
    CommandsCommand *command = [[CommandsCommand alloc] init];
    [app out:[NSString stringWithFormat:@"Help for command \"%@\"", name]];
    [app out:[command textForCommand:instance showFull:YES]];
  } else if ([instance conformsToProtocol:@protocol(Option)]) {
    // Options
    OptionsCommand *command = [[OptionsCommand alloc] init];
    [app out:[NSString stringWithFormat:@"Help for option \"%@\"", name]];
    [app out:[command textForOption:instance showFull:YES]];
  } else if ([instance conformsToProtocol:@protocol(Output)]) {
    // Outputs
    OutputsCommand *command = [[OutputsCommand alloc] init];
    [app out:[NSString stringWithFormat:@"Help for output \"%@\"", name]];
    [app out:[command textForOutput:instance showFull:YES]];
  }
  return YES;
}

@end
