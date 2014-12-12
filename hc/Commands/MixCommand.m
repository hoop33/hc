//
// Created by Rob Warner on 12/12/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "MixCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"


@implementation MixCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2 || params.count == 3) {
    Color *color1 = [[Color alloc] initWithHexCode:params[0]];
    Color *color2 = [[Color alloc] initWithHexCode:params[1]];
    int weight = params.count == 3 ? [params[2] intValue] : 50;
    response = [[Response alloc] init];
    [response add:color1];
    [response add:color2];
    [response add:[color1 mix:color2 weight:weight]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify two colors and optionally a weight."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <color> [weight]";
}

- (NSString *)help {
  return @"Mixes two colors using the specified weight, or 50 if weight not specified.";
}

- (NSString *)summary {
  return @"Mix two colors";
}

@end