//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "VersionCommand.h"
#import "Response.h"
#import "App.h"

@implementation VersionCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  // Suppress unused parameter warnings
  (void)params;
  (void)error;

  Response *response = [[Response alloc] init];
  response.message = [[App app] version];
  return response;
}

- (NSString *)usage {
  return @"";
}

- (NSString *)help {
  return @"Displays the version.";
}

- (NSString *)description {
  return @"Display version";
}

@end
