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

- (NSString *)summary {
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

- (BOOL)show:(NSString *)command {
  return YES;
}

@end