//
//  OverlayCommand.m
//  hc
//
//  Created by Rob Warner on 3/3/15.
//  Copyright (c) 2015 Rob Warner. All rights reserved.
//

#import "OverlayCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation OverlayCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color1 = [[Color alloc] initWithHexCode:params[0]];
    Color *color2 = [[Color alloc] initWithHexCode:params[1]];
    response = [[Response alloc] init];
    [response add:color1];
    [response add:color2];
    [response add:[color1 overlay:color2]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify the two colors to overlay."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <color>";
}

- (NSString *)help {
  return @"Combines multiply and screen to make light colors lighter and dark colors darker.";
}

- (NSString *)description {
  return @"Combine multiply and screen";
}

@end
