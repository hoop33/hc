//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "VersionOption.h"


@implementation VersionOption

- (NSString *)shortName {
  return @"v";
}

- (NSString *)description {
  return @"Display version";
}

- (NSString *)help {
  return @"Displays the version.";
}

- (NSUInteger)numberOfParameters {
  return 0;
}

- (NSArray *)allowedValues {
  return nil;
}

- (OptionType)type {
  return OptionTypeNone;
}

@end