//
// Created by Rob Warner on 12/12/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "GrayscaleCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"


@implementation GrayscaleCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 1) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color grayscale]];
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
  return @"Desaturate a color completely, making it gray.";
}

- (NSString *)description {
  return @"Desaturate color completely";
}

@end
