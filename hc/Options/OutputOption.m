//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "OutputOption.h"
#import "Utils.h"

@implementation OutputOption

- (NSString *)shortName {
  return @"o";
}

- (NSString *)description {
  return @"Use <output> to output data";
}

- (NSString *)help {
  return @"Uses the specified output to display output data.";
}

- (NSUInteger)numberOfParameters {
  return 1;
}

- (NSArray *)allowedValues {
  NSMutableArray *values = [NSMutableArray array];
  for (Class cls in [Utils allOutputs]) {
    [values addObject:[Utils nameForOutput:[[cls alloc] init]]];
  }
  return values;
}

- (OptionType)type {
  return OptionTypeString;
}

@end