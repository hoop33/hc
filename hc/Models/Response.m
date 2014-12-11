//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "Response.h"
#import "Color.h"


@implementation Response

- (void)add:(Color *)color {
  if (_colors == nil) {
    _colors = [NSMutableArray array];
  }
  [_colors addObject:color];
}

@end