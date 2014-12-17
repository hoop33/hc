//
// Created by Rob Warner on 12/12/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "SpinCommand.h"
#import "Color.h"
#import "Response.h"
#import "App.h"
#import "ErrorCodes.h"


@implementation SpinCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    int degrees = [params[1] intValue];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color spin:degrees]];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[[App app] errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify a color and the degrees."
                               }];
    }
  }
  return response;
}

- (NSString *)usage {
  return @"<color> <degrees>";
}

- (NSString *)help {
  return @"Spins a color by the specified degrees.";
}

- (NSString *)description {
  return @"Spin color";
}

@end
