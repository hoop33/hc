//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "OutputsCommand.h"
#import "Utils.h"
#import "Output.h"
#import "Response.h"


@implementation OutputsCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  NSMutableString *message = [[NSMutableString alloc] init];
  for (Class cls in [Utils allOutputs]) {
    id <Output> output = [[cls alloc] init];
    [message appendFormat:@"%-12s%@\n",
                          [[Utils nameForOutput:output] UTF8String],
                          [output summary]];
  }
  Response *response = [[Response alloc] init];
  response.message = message;
  return response;
}

- (NSString *)usage {
  return @"";
}

- (NSString *)help {
  return @"Lists all available outputs.";
}

- (NSString *)summary {
  return @"List available outputs";
}
@end