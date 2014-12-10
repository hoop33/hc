//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "DarkenCommand.h"
#import "ErrorCodes.h"
#import "App.h"
#import "Color.h"

@implementation DarkenCommand

- (BOOL)run:(NSArray *)params error:(NSError **)error {
  BOOL success = YES;
  App *app = [App app];

  if (params.count == 2) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    if (color != nil) {

    } else {
      if (error != NULL) {
        *error = [NSError errorWithDomain:[app errorDomain]
                                     code:ErrorCodeBadInput
                                 userInfo:@{
                                   NSLocalizedDescriptionKey :
                                   [NSString stringWithFormat:@"'%@' is not a valid color", params[0]]
                                 }];

      }
      success = NO;
    }
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
  return @"Darkens a color by the specified percent (expressed as a decimal).";
}

- (NSString *)summary {
  return @"Darken color";
}

@end