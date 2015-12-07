//
//  CountryPickerViewController.h
//  CurrencyConverter
//
//  Created by John Andrews on 12/7/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryPickerDelegate <NSObject>
- (void)userSelectedCountry:(NSString *)abbreviation;

@end

@interface CountryPickerViewController : UIViewController
- (IBAction)countryFlagButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) id<CountryPickerDelegate> countryPickerDelegate;

@end
