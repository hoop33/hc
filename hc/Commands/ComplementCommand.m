//
// Created by Rob Warner on 12/10/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "ComplementCommand.h"
#import "App.h"
#import "Color.h"
#import "ErrorCodes.h"

@implementation ComplementCommand

- (BOOL)run:(NSArray *)params error:(NSError **)error {
  BOOL success = YES;
  App *app = [App app];

  if (params.count == 1) {
    Color *color = [[Color alloc] initWithHexCode:params[0]];
    Color *complement = [color complement];
    [app out:complement];
  } else {
    if (error != NULL) {
      *error = [NSError errorWithDomain:[app errorDomain]
                                   code:ErrorCodeBadInput
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                 @"You must specify a color."
                               }];
    }
    success = NO;
  }
  return success;
}

- (NSString *)usage {
  return @"<color>";
}

- (NSString *)help {
  return @"Returns the RGB complement of the specified color.";
}

- (NSString *)summary {
  return @"Show complement";
}
@end