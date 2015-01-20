//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "ShowCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation ShowCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 1) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    response = [[Response alloc] init];
    [response add:color];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify a color."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color>";
}

- (NSString *)help {
  return @"Shows a color.";
}

- (NSString *)description {
  return @"Show color";
}

@end
