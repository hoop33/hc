//
//  AverageCommand.m
//  hc
//
//  Created by Rob Warner on 3/3/15.
//  Copyright (c) 2015 Rob Warner. All rights reserved.
//

#import "AverageCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation AverageCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color1 = [[Color alloc] initWithHexCode:params[0]];
    Color *color2 = [[Color alloc] initWithHexCode:params[1]];
    response = [[Response alloc] init];
    [response add:color1];
    [response add:color2];
    [response add:[color1 average:color2]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify the two colors to average."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <color>";
}

- (NSString *)help {
  return @"Averages the two colors.";
}

- (NSString *)description {
  return @"Average colors";
}

@end
