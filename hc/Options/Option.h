//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OptionType) {
  OptionTypeNone = 0,
  OptionTypeBoolean,
  OptionTypeInteger,
  OptionTypeString
};

@protocol Option <NSObject>

- (NSString *)shortName;
- (NSString *)summary;
- (NSString *)help;
- (NSUInteger)numberOfParameters;
- (NSArray *)allowedValues;
- (OptionType)type;

@end