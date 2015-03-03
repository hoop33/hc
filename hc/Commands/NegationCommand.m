//
//  NegationCommand.m
//  hc
//
//  Created by Rob Warner on 3/3/15.
//  Copyright (c) 2015 Rob Warner. All rights reserved.
//

#import "NegationCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation NegationCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color1 = [[Color alloc] initWithHexCode:params[0]];
    Color *color2 = [[Color alloc] initWithHexCode:params[1]];
    response = [[Response alloc] init];
    [response add:color1];
    [response add:color2];
    [response add:[color1 negation:color2]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify the two colors to negation."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <color>";
}

- (NSString *)help {
  return @"Does the opposite of difference.";
}

- (NSString *)description {
  return @"Opposite of difference";
}

@end
