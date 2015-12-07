//
//  ViewController.m
//  CurrencyConverter
//
//  Created by John Andrews on 12/6/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import "ViewController.h"

static NSString *exchangeRatesLink = @"http://api.fixer.io/latest?base=USD";
static NSString *exchangeRatesKey = @"exchangeRates";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getConversionRateForCurrency];
}



#pragma mark Actions

- (IBAction)convertedToButtonPressed:(UIButton *)sender {
}

- (IBAction)convertFromButtonPressed:(UIButton *)sender {
}

- (IBAction)digitPressed:(UIButton *)sender {
}

- (IBAction)switchPressed:(UIButton *)sender {
}

- (IBAction)backPressed:(id)sender {
}

- (IBAction)clearPressed:(UIButton *)sender {
}

#pragma mark Networking

- (void)getConversionRateForCurrency {
    
    __weak __typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:exchangeRatesLink]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error && data) {
                        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        [weakSelf parseData:object];
                    }
                }] resume];
}

- (void)parseData:(NSDictionary *)responseObject {

    NSMutableDictionary *conversionAmounts = [NSMutableDictionary dictionary];
    NSDictionary *exchangeRatesList = [responseObject objectForKey:@"rates"];
    for (NSString *abbreviations in exchangeRatesList) {
        if ([abbreviations isEqualToString:@"GBP"] ||
            [abbreviations isEqualToString:@"EUR"] ||
            [abbreviations isEqualToString:@"JPY"] ||
            [abbreviations isEqualToString:@"BRL"]) {
            [conversionAmounts setObject:[exchangeRatesList objectForKey:abbreviations] forKey:abbreviations];
        }
    }
    [self saveToDevice:conversionAmounts];
}

#pragma mark Persistence

- (void)saveToDevice:(NSMutableDictionary *)exchangeRates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:exchangeRates forKey:exchangeRatesKey];
    [defaults synchronize];
    NSLog(@"exchangeRates = %@", exchangeRates);
}

- (void)dealloc {
    
}

@end
