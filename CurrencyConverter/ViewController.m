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
static NSString *defaultCurrencySetting = @"0.0";

@interface ViewController ()
@property (strong, nonatomic) NSString *lastSelection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getConversionRateForCurrency];
    [self setUpUI:nil];
}

- (void)setUpUI:(NSString *)abbreviation {
    self.convertFromLabel.text = defaultCurrencySetting;
    self.convertedToLabel.text = defaultCurrencySetting;
    
    if (!abbreviation) {
        return;
    }
    self.convertedToButton.titleLabel.numberOfLines = 2;
    self.convertedToButton.titleLabel.text = abbreviation;
    self.convertedToButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.convertedToFlag.image = [UIImage imageNamed:abbreviation];
    NSString *conversionRate = [[self retrieveExchangeRatesFromDevice] objectForKey:abbreviation];
    self.conversionRateLabel.text = [NSString stringWithFormat:@"1.00 USD = %@ %@", conversionRate, abbreviation];
}

- (void)pickCurrencyFor:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.countryPickerVC = [storyboard instantiateViewControllerWithIdentifier:@"CountryPickerVC"];
    self.countryPickerVC.countryPickerDelegate = self;
    [self presentViewController:self.countryPickerVC animated:YES completion:nil];
}

-(void)userSelectedCountry:(NSString *)abbreviation {
    self.lastSelection = abbreviation;
    [self setUpUI:abbreviation];
}

#pragma mark Actions

- (IBAction)convertedToButtonPressed:(UIButton *)sender {
    [self pickCurrencyFor:sender];
}

- (IBAction)digitPressed:(UIButton *)sender {
    if ([self.convertFromLabel.text isEqualToString:defaultCurrencySetting]) {
        self.convertFromLabel.text = @"";
    }
    NSString *newString = [self.convertFromLabel.text stringByAppendingString:sender.titleLabel.text];
    NSString *removeCommaString = [newString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:[removeCommaString doubleValue]]];
    self.convertFromLabel.text = formatted;
    
    [self calculateConversion];
}

- (IBAction)backPressed:(UIButton *)sender {
    NSString *newString = [self.convertFromLabel.text substringToIndex:[self.convertFromLabel.text length]-1];
    self.convertFromLabel.text = newString;
    [self calculateConversion];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.convertFromLabel.text = defaultCurrencySetting;
    self.convertedToLabel.text = defaultCurrencySetting;
}

- (void)calculateConversion {
    double rate = [[[self retrieveExchangeRatesFromDevice] objectForKey:self.lastSelection] doubleValue];
    NSString *removeCommaString = [self.convertFromLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    double amount = [removeCommaString doubleValue];
    double convertedAmount = rate * amount;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:convertedAmount]];

    self.convertedToLabel.text = formatted;
}

#pragma mark Networking

- (void)getConversionRateForCurrency {
    ViewController *__weak weakSelf = self;
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
}

- (NSDictionary *)retrieveExchangeRatesFromDevice {
    return [[NSUserDefaults standardUserDefaults] objectForKey:exchangeRatesKey];
}

@end
