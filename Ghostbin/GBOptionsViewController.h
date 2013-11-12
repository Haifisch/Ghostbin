//
//  GBOptionsViewController.h
//  Ghostbin
//
//  Created by Haifisch on 11/11/13.
//  Copyright (c) 2013 Evolse Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBOptionsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *dataArray;
}
@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITextField *languageField;

- (IBAction)saveOptions:(id)sender;
- (IBAction)done:(id)sender;

@end
