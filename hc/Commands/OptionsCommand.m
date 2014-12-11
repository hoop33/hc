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
  NSMutableString *message = [[NSMutableString alloc] init];
  for (Class cls in [Utils allOptions]) {
    id <Option> option = [[cls alloc] init];
    NSString *name = [Utils nameForOption:option];
    if ([option numberOfParameters] == 1) {
      name = [name stringByAppendingFormat:@" <%@>", name];
    }
    [message appendFormat:@"-%@, --%-18s%@\n",
                          [option shortName],
                          [name UTF8String],
                          [option summary]];
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

- (NSString *)summary {
  return @"List available options";
}

@end