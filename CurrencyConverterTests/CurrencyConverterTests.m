//
//  CurrencyConverterTests.m
//  CurrencyConverterTests
//
//  Created by John Andrews on 12/6/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

static NSString *exchangeRatesKey = @"exchangeRates";

@interface CurrencyConverterTests : XCTestCase
@property (strong, nonatomic) ViewController *viewcontroller;
@end

@implementation CurrencyConverterTests

- (void)setUp {
    [super setUp];
    self.viewcontroller = [[ViewController alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testResponseObjectIsParsedCorrectly {
    NSDictionary *exchangeRates = @{@"rates" : [self getDictionaryOfExchangeRates:YES]};
    
    [self.viewcontroller parseData:exchangeRates];
    int expctedDictCount = 4;
    
    NSDictionary *savedDict = [[NSUserDefaults standardUserDefaults] objectForKey:exchangeRatesKey];
    XCTAssertEqual(expctedDictCount, savedDict.count, @"Expected number = %d, Actual number = %lu", expctedDictCount, (unsigned long)savedDict.count);
}

- (void)testExchangeRatesSavedToDevice {
    NSDictionary *exchangeRates = [self getDictionaryOfExchangeRates:NO];
    [self.viewcontroller saveToDevice:exchangeRates];
    
    NSDictionary *savedDict = [[NSUserDefaults standardUserDefaults] objectForKey:exchangeRatesKey];
    
    XCTAssertEqualObjects(exchangeRates, savedDict, @"Expected dictionary = %@, Actual dictionary = %@", exchangeRates, savedDict);
    XCTAssertEqual(exchangeRates.count, savedDict.count, @"Expected number = %lu, Actual number = %lu", (unsigned long)exchangeRates.count, (unsigned long)savedDict.count);
    
}

#pragma mark Helper

- (NSDictionary *)getDictionaryOfExchangeRates:(BOOL)withExtra {
    NSDictionary *exchangeRates;
    if (withExtra) {
        exchangeRates = @{@"BRL" : @"3.7399",
                          @"EUR" : @"0.92515",
                          @"GBP" : @"0.66398",
                          @"JPY" : @"123.42",
                          @"RON" : @"4.145",
                          @"RUB" : @"69.045",
                          @"SEK" : @"8.5288",
                          @"SGD" : @"1.4054",
                          @"THB" : @"35.86",
                          @"TRY" : @"2.9003",
                          @"ZAR" : @"14.487"};
    } else {
        exchangeRates = @{@"BRL" : @"3.7399",
                          @"EUR" : @"0.92515",
                          @"GBP" : @"0.66398",
                          @"JPY" : @"123.42"};
    }
    return exchangeRates;
}

@end
