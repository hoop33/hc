//
// Created by Rob Warner on 12/10/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "LightenCommand.h"
#import "App.h"
#import "Color.h"
#import "ErrorCodes.h"
#import "Response.h"

@implementation LightenCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    int percent = [params[1] intValue];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color lighten:percent]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify a color and a percent."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <percent>";
}

- (NSString *)help {
  return @"Lighten a color by the specified percent (expressed as a decimal).";
}

- (NSString *)description {
  return @"Lighten color";
}

@end
