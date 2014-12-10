//
// Created by Rob Warner on 12/10/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "LightenCommand.h"
#import "App.h"
#import "Color.h"
#import "ErrorCodes.h"

@implementation LightenCommand

- (BOOL)run:(NSArray *)params error:(NSError **)error {
  BOOL success = YES;
  App *app = [App app];

  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    int percent = [params[1] intValue];
    Color *lighter = [color lighten:percent];
    [app out:lighter];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[app errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify a color and a percent."
                               }];
    }
    success = NO;
  }
  return success;
}

- (NSString *)usage {
  return @"<color> <percent>";
}

- (NSString *)help {
  return @"Lighten a color by the specified percent (expressed as a decimal).";
}

- (NSString *)summary {
  return @"Lighten color";
}

@end