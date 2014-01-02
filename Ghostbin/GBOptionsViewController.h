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
@property (nonatomic, retain) NSMutableArray *selectionArray;

@property (strong, nonatomic) IBOutlet UITextField *languageField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
- (IBAction)segmentLanguage:(id)sender;

- (IBAction)saveOptions:(id)sender;
- (IBAction)done:(id)sender;

@end
