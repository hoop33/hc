//
// Created by Rob Warner on 12/10/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "ComplementCommand.h"
#import "Color.h"
#import "ErrorCodes.h"
#import "Response.h"
#import "App.h"

@implementation ComplementCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 1) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color complement]];
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
  return @"Returns the RGB complement of the specified color.";
}

- (NSString *)description {
  return @"Show complement";
}
@end