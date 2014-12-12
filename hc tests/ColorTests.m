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
  Color *color = [[Color alloc] initWithRGB:255 green:0 blue:0];
  XCTAssertEqualObjects(@"#ff0000", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeGreen {
  Color *color = [[Color alloc] initWithRGB:0 green:255 blue:0];
  XCTAssertEqualObjects(@"#00ff00", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeBlue {
  Color *color = [[Color alloc] initWithRGB:0 green:0 blue:255];
  XCTAssertEqualObjects(@"#0000ff", color.hexCode);
}

- (void)testColorRGBShouldFillHexCodeGray {
  Color *color = [[Color alloc] initWithRGB:127 green:127 blue:127];
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

- (void)testDarkenWith25ShouldDecrease25 {
  Color *color = [[Color alloc] initWithHSL:60 saturation:50 lightness:50];
  Color *darker = [color darken:25];
  XCTAssertEqual(25, darker.lightness);
}

- (void)testLightenWith25ShouldIncrease25 {
  Color *color = [[Color alloc] initWithHSL:60 saturation:50 lightness:50];
  Color *lighter = [color lighten:25];
  XCTAssertEqual(75, lighter.lightness);
}

- (void)testLightenWithZeroShouldBeUnchanged {
  Color *color = [[Color alloc] initWithHexCode:@"#CCC"];
  Color *lighter = [color lighten:0];
  XCTAssertEqualObjects(color.hexCode, lighter.hexCode);
}

- (void)testLightenWithWith100ShouldBeWhite {
  Color *color = [[Color alloc] initWithHexCode:@"#000"];
  Color *lighter = [color lighten:100];
  XCTAssertEqualObjects(@"#ffffff", lighter.hexCode);
}

- (void)testLightenShouldComeCloseToLessExample {
  Color *color = [[Color alloc] initWithHSL:90 saturation:80 lightness:50];
  Color *lighter = [color lighten:20];
  XCTAssertEqualObjects(@"#b2ef75", lighter.hexCode);
}

- (void)testHSLShouldBeCalculatedFromHexCode {
  Color *color = [[Color alloc] initWithHexCode:@"0ff"];
  XCTAssertEqual(180, color.hue);
  XCTAssertEqual(100, color.saturation);
  XCTAssertEqual(50, color.lightness);
}

- (void)testHSLShouldBeCalculatedFromRGB {
  Color *color = [[Color alloc] initWithRGB:128 green:128 blue:0];
  XCTAssertEqual(60, color.hue);
  XCTAssertEqual(100, color.saturation);
  XCTAssertEqual(25, color.lightness);
}

- (void)testHexCodeShouldBeCalculatedFromHSL {
  Color *color = [[Color alloc] initWithHSL:240 saturation:100 lightness:50];
  XCTAssertEqualObjects(@"#0000ff", color.hexCode);
}

- (void)testRGBShouldBeCalculatedFromHSL {
  Color *color = [[Color alloc] initWithHSL:240 saturation:100 lightness:50];
  XCTAssertEqual(0, color.red);
  XCTAssertEqual(0, color.green);
  XCTAssertEqual(255, color.blue);
}

- (void)testComplementOfRedShouldBeCyan {
  Color *color = [[Color alloc] initWithHexCode:@"f00"];
  Color *complement = [color complement];
  XCTAssertEqualObjects(@"#00ffff", complement.hexCode);
}

- (void)testSpinOf0ShouldBeUnchanged {
  Color *color = [[Color alloc] initWithHSL:340
                                 saturation:75
                                  lightness:72];
  Color *spin = [color spin:0];
  XCTAssertEqualObjects(color.hexCode, spin.hexCode);
}

- (void)testSpinOf360ShouldBeUnchanged {
  Color *color = [[Color alloc] initWithHSL:340
                                 saturation:75
                                  lightness:72];
  Color *spin = [color spin:360];
  XCTAssertEqualObjects(color.hexCode, spin.hexCode);
}

- (void)testSpinOf365ShouldBeSpinOf5 {
  Color *color = [[Color alloc] initWithHexCode:@"123456"];
  Color *spin1 = [color spin:365];
  Color *spin2 = [color spin:5];
  XCTAssertEqualObjects(spin1.hexCode, spin2.hexCode);
}

- (void)testSpinOfNeg355ShouldBeSpinOf5 {
  Color *color = [[Color alloc] initWithHexCode:@"123456"];
  Color *spin1 = [color spin:-355];
  Color *spin2 = [color spin:5];
  XCTAssertEqualObjects(spin1.hexCode, spin2.hexCode);
}

@end
