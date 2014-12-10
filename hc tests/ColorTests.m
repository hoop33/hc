//
//  ColorTests.m
//  hc
//
//  Created by Rob Warner on 12/10/14.
//  Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "Color.h"

@interface ColorTests : XCTestCase

@end

@implementation ColorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testColorShouldParseWithHash {
  Color *color = [[Color alloc] initWithHexCode:@"#000000"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorShouldParseWithoutHash {
  Color *color = [[Color alloc] initWithHexCode:@"000000"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorShouldParseWithHash3Chars {
  Color *color = [[Color alloc] initWithHexCode:@"#000"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorShouldParseWithoutHash3Chars {
  Color *color = [[Color alloc] initWithHexCode:@"000"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorShouldParseWithLettersAndNumbers {
  Color *color = [[Color alloc] initWithHexCode:@"aa1177"];
  XCTAssertEqualObjects(@"#aa1177", color.hexCode);
}

- (void)testColorShouldParseWithLettersAndNumbers3 {
  Color *color = [[Color alloc] initWithHexCode:@"a17"];
  XCTAssertEqualObjects(@"#aa1177", color.hexCode);
}

- (void)testColorShouldBeBlackWhenNot3or6 {
  Color *color = [[Color alloc] initWithHexCode:@"abcd"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorShouldBeBlackWhenInvalidCharacters {
  Color *color = [[Color alloc] initWithHexCode:@"abghez"];
  XCTAssertEqualObjects(@"#000000", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeRed {
  Color *color = [[Color alloc] initWithRGB:1.0 green:0.0 blue:0.0];
  XCTAssertEqualObjects(@"#ff0000", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeGreen {
  Color *color = [[Color alloc] initWithRGB:0.0 green:1.0 blue:0.0];
  XCTAssertEqualObjects(@"#00ff00", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeBlue {
  Color *color = [[Color alloc] initWithRGB:0.0 green:0.0 blue:1.0];
  XCTAssertEqualObjects(@"#0000ff", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeGray {
  Color *color = [[Color alloc] initWithRGB:0.5 green:0.5 blue:0.5];
  XCTAssertEqualObjects(@"#7f7f7f", color.hexCode);
}

- (void)testDarkenWithZeroShouldBeUnchanged {
  Color *color = [[Color alloc] initWithHexCode:@"#CCC"];
  Color *darker = [color darken:0];
  XCTAssertEqualObjects(color.hexCode, darker.hexCode);
}

- (void)testDarkenWithWith100ShouldBeBlack {
  Color *color = [[Color alloc] initWithHexCode:@"#fff"];
  Color *darker = [color darken:100];
  XCTAssertEqualObjects(@"#000000", darker.hexCode);
}

- (void)testLightenWithZeroShouldBeUnchanged {
  Color *color = [[Color alloc] initWithHexCode:@"#CCC"];
  Color *lighter = [color lighten:0];
  XCTAssertEqualObjects(color.hexCode, lighter.hexCode);
}

- (void)testLightenWithWith100ShouldBe110PercentLighter {
  Color *color = [[Color alloc] initWithHexCode:@"#111"];
  Color *lighter = [color lighten:100];
  XCTAssertEqualObjects(@"#222222", lighter.hexCode);
}

@end
