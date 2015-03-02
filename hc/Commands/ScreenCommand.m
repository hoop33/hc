//
//  ScreenCommand.m
//  hc
//
//  Created by Rob Warner on 3/2/15.
//  Copyright (c) 2015 Rob Warner. All rights reserved.
//

#import "ScreenCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation ScreenCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color1 = [[Color alloc] initWithHexCode:params[0]];
    Color *color2 = [[Color alloc] initWithHexCode:params[1]];
    response = [[Response alloc] init];
    [response add:color1];
    [response add:color2];
    [response add:[color1 screen:color2]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify the two colors to screen."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <color>";
}

- (NSString *)help {
  return @"Does the opposite of the multiply command.";
}

- (NSString *)description {
  return @"Opposite of multiply";
}

@end
