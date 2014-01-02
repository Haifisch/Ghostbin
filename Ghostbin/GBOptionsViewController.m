//
//  GBOptionsViewController.m
//  Ghostbin
//
//  Created by Haifisch on 11/11/13.
//  Copyright (c) 2013 Evolse Limited. All rights reserved.
//

#import "GBOptionsViewController.h"

@interface GBOptionsViewController ()

@end

@implementation GBOptionsViewController
@synthesize dataArray,selectionArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //begin uitoolbar
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 44);
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = frame;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(done:)];
    UIBarButtonItem *middleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    middleItem.width = 227;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveOptions:)];
    NSArray *toolBarItemsArray = [[NSArray alloc] initWithObjects:leftButtonItem,middleItem,rightButtonItem, nil];
    [toolbar setItems:toolBarItemsArray animated:NO];
    [self.view addSubview:toolbar];
    //end uitoolbar
    
    self.view.backgroundColor = [UIColor colorWithRed:42/255.0f green:42/255.0f blue:42/255.0f alpha:1.0f];
    // Init the data array.
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ghostbin.com/languages.json"]];
    
    // Convert your JSON object to an 'NS' object
    NSError *error;
    id myJsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%lu", (unsigned long)[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]);
    dataArray = [[NSMutableArray alloc] init];
    int count = 0;
    while (count < [[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]) {
        //NSLog(@"%i", count);
        [dataArray addObject:[[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
        count++;
    }
    count = 0;
    while (count < [[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]) {
        //NSLog(@"%i", count);
        [selectionArray addObject:[[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
        count++;
    }
    //NSLog(@"%@", [[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:3] objectForKey:@"name"]);
    //dataArray = [[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:0] objectForKey:@"name"];
    [self.languagePicker setDataSource: self];
    [self.languagePicker setDelegate: self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentLanguage:(id)sender {
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ghostbin.com/languages.json"]];
    
    // Convert your JSON object to an 'NS' object
    NSError *error;
    id myJsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%lu", (unsigned long)[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]);
    dataArray = [[NSMutableArray alloc] init];
    selectionArray = [[NSMutableArray alloc] init];

    if ([[self.segmentControl titleForSegmentAtIndex: [self.segmentControl selectedSegmentIndex]] isEqualToString:@"Text"]) {
        int count = 0;
        while (count < [[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]) {
            NSLog(@"%i", count);
            [dataArray addObject:[[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
            [selectionArray addObject:[[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"id"]];
            count++;
        }
    }
    if ([[self.segmentControl titleForSegmentAtIndex: [self.segmentControl selectedSegmentIndex]] isEqualToString:@"Common"]) {
        int count = 0;
        while (count < [[[myJsonObj objectAtIndex:1] objectForKey:@"languages"] count]) {
            NSLog(@"%i", count);
            [dataArray addObject:[[[[[myJsonObj objectAtIndex:1] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
            [selectionArray addObject:[[[[[myJsonObj objectAtIndex:1] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"id"]];
            count++;
        }
    }
    if ([[self.segmentControl titleForSegmentAtIndex: [self.segmentControl selectedSegmentIndex]] isEqualToString:@"Other"]) {
        int count = 0;
        while (count < [[[myJsonObj objectAtIndex:2] objectForKey:@"languages"] count]) {
            NSLog(@"%i", count);
            [dataArray addObject:[[[[[myJsonObj objectAtIndex:2] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
            [selectionArray addObject:[[[[[myJsonObj objectAtIndex:2] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"id"]];
            count++;
        }
    }
    [self.languagePicker reloadAllComponents];
}

- (IBAction)saveOptions:(id)sender {
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:self.timeField.text forKey:@"expiry_time"];
    [storage synchronize];

}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"You selected this: %@", [dataArray objectAtIndex: row]);
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:[selectionArray objectAtIndex:row] forKey:@"language_id"];
    [storage synchronize];
    NSLog(@"language_id: %@", [storage objectForKey:@"language_id"]);

    self.languageField.text = [dataArray objectAtIndex:row];
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // Get the text of the row.
    NSString *rowItem = [dataArray objectAtIndex:row];
    
    // Create and init a new UILabel.
    // We must set our label's width equal to our picker's width.
    // We'll give the default height in each row.
    UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
    
    // Center the text.
    [lblRow setTextAlignment:NSTextAlignmentCenter];
    
    // Make the text color red.
    [lblRow setTextColor: [UIColor redColor]];
    
    // Add the text.
    [lblRow setText:rowItem];
    
    // Clear the background color to avoid problems with the display.
    [lblRow setBackgroundColor:[UIColor clearColor]];
    
    // Return the label.
    return lblRow;
}


@end
