//
//  CountryPickerViewController.m
//  CurrencyConverter
//
//  Created by John Andrews on 12/7/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import "CountryPickerViewController.h"

@interface CountryPickerViewController ()

@end

@implementation CountryPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)countryFlagButtonPressed:(UIButton *)sender {
    NSArray *countryAbbreviations = @[@"BRL", @"JPY", @"EUR", @"GBP"];
    [self.countryPickerDelegate userSelectedCountry:countryAbbreviations[sender.tag]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
