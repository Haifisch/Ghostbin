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
@synthesize dataArray;
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
    self.view.backgroundColor = [UIColor colorWithRed:42/255.0f green:42/255.0f blue:42/255.0f alpha:1.0f];
    // Init the data array.
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ghostbin.com/languages.json"]];
    
    // Convert your JSON object to an 'NS' object
    NSError *error;
    id myJsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%lu", (unsigned long)[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]);
    dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
    /*[dataArray addObject:@"Plain Text"];
    [dataArray addObject:@"Objective-C + Logos"];
    [dataArray addObject:@"Objective-C"];
    [dataArray addObject:@"C"];
    [dataArray addObject:@"Five"];*/
    int count = 0;
    while (count < [[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] count]) {
        NSLog(@"%i", count);
     [dataArray addObject:[[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:count] objectForKey:@"name"]];
        count++;
    }
    //NSLog(@"%@", [[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:3] objectForKey:@"name"]);
    //dataArray = [[[[[myJsonObj objectAtIndex:0] objectForKey:@"languages"] allObjects] objectAtIndex:0] objectForKey:@"name"];
    [self.languagePicker setDataSource: self];
    [self.languagePicker setDelegate: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveOptions:(id)sender {
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
    self.languageField.text = [dataArray objectAtIndex: row];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // Get the text of the row.
    NSString *rowItem = [dataArray objectAtIndex: row];
    
    // Create and init a new UILabel.
    // We must set our label's width equal to our picker's width.
    // We'll give the default height in each row.
    UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
    
    // Center the text.
    [lblRow setTextAlignment:UITextAlignmentCenter];
    
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
