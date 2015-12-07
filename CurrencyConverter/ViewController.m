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
static NSString *lastConvertFrom = @"lastConvertFrom";
static NSString *lastConvertedTo = @"lastConvertedTo";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self retrieveExchangeRatesFromDevice] count] != 4) {
        [self getConversionRateForCurrency];
    }
    [self setUpUI];
}

- (void)setUpUI {

    self.convertedToButton.titleLabel.numberOfLines = 2;
    self.convertedToButton.titleLabel.text = @"\nTap to change";
    
    self.convertFromLabel.text = @"0.0";
    self.convertedToLabel.text = @"0.0";
    
//    self.conversionRateLabel.text;
}


- (void)pickCurrencyFor:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.countryPickerVC = [storyboard instantiateViewControllerWithIdentifier:@"CountryPickerVC"];
    self.countryPickerVC.countryPickerDelegate = self;
    [self presentViewController:self.countryPickerVC animated:YES completion:nil];
}

-(void)userSelectedCountry:(NSString *)abbreviation {
    NSLog(@"delegation abbreviationg = %@", abbreviation);
}

#pragma mark Actions

- (IBAction)convertedToButtonPressed:(UIButton *)sender {
    [self pickCurrencyFor:sender];
}

- (IBAction)convertFromButtonPressed:(UIButton *)sender {
    [self pickCurrencyFor:sender];
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

- (void)saveToDevice:(NSDictionary *)exchangeRates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:exchangeRates forKey:exchangeRatesKey];
    [defaults synchronize];
    NSLog(@"exchangeRates = %@", exchangeRates);
}

- (NSDictionary *)retrieveExchangeRatesFromDevice {
    return [[NSUserDefaults standardUserDefaults] objectForKey:exchangeRatesKey];
}

- (void)dealloc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
}

@end
