//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "DarkenCommand.h"
#import "ErrorCodes.h"
#import "Color.h"
#import "App.h"
#import "Response.h"

@implementation DarkenCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    int percent = [params[1] intValue];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color darken:percent]];
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
  return @"Darkens a color by the specified percent (expressed as a decimal).";
}

- (NSString *)description {
  return @"Darken color";
}

@end
