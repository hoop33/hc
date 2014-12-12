//
// Created by Rob Warner on 12/12/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "DesaturateCommand.h"
#import "Response.h"
#import "Color.h"
#import "App.h"
#import "ErrorCodes.h"

@implementation DesaturateCommand

- (Response *)run:(NSArray *)params error:(NSError **)error {
  Response *response = nil;
  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    int percent = [params[1] intValue];
    response = [[Response alloc] init];
    [response add:color];
    [response add:[color desaturate:percent]];
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
  return @"Desaturate a color by the specified percent (expressed as a decimal).";
}

- (NSString *)summary {
  return @"Desaturate color";
}
@end