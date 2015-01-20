//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "OptionsCommand.h"
#import "Response.h"
#import "Utils.h"
#import "Option.h"

@implementation OptionsCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  // Suppress unused parameter warnings
  (void)params;
  (void)error;

  NSMutableString *message = [[NSMutableString alloc] init];
  for (Class cls in [Utils allOptions]) {
    id <Option> option = [[cls alloc] init];
    [message appendString:[self textForOption:option showFull:NO]];
  }
  Response *response = [[Response alloc] init];
  response.message = message;
  return response;
}

- (NSString *)usage {
  return @"";
}

- (NSString *)help {
  return @"Lists all available options.";
}

- (NSString *)description {
  return @"List available options";
}

- (NSString *)textForOption:(id <Option>)option showFull:(BOOL)showFull {
  NSMutableString *text = [NSMutableString string];
  NSString *name = [Utils nameForOption:option];
  if ([option numberOfParameters] == 1) {
    name = [name stringByAppendingFormat:@" <%@>", name];
  }

  [text appendFormat:@"   -%@, --%-18s%@\n",
                     [option shortName],
                     [name UTF8String],
                     [option description]];
  if (showFull) {
    NSArray *values = [option allowedValues];
    if ([values count] > 0) {
      [text appendFormat:@"   options: %@\n", [values componentsJoinedByString:@", "]];
    }
    [text appendFormat:@"\n   %@\n", [option help]];
  }
  return text;
}

@end
