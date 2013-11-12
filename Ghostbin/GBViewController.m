//
//  GBViewController.m
//  Ghostbin
//
//  Created by James Long on 31/10/2013.
//  Copyright (c) 2013 Evolse Limited. All rights reserved.
//

#import "GBViewController.h"
#import "Chromatism/Chromatism.h"

@interface GBViewController ()

@end

@implementation GBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //For keys and such
    storage = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Ghostbin";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(options:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Paste!" style:UIBarButtonItemStylePlain target:self action:@selector(paste:)];
    
    JLTextView *textView = [[JLTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:textView];
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [textView setBackgroundColor:[UIColor colorWithRed:42/255.0f green:42/255.0f blue:42/255.0f alpha:1.0f]];
//    [textView setTextColor:[UIColor whiteColor]];
//    [self.view addSubview:textView];
//    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"html"];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [webView setBackgroundColor:[UIColor clearColor]];
////    [webView loadHTMLString:template baseURL:[NSURL URLWithString:@""]];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.view addSubview:webView];
    
    
    // Navigation bar, subtitle
    
    UIView *customView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 200.0f, 20.0f)];
    subtitleLabel.font = [UIFont systemFontOfSize:10.0f];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"Ghostbin";
    [titleLabel sizeToFit];
    
    subtitleLabel.text = @"Not Set";
    [subtitleLabel sizeToFit];
    
    
    
    customView.frame = CGRectMake(0,0, titleLabel.frame.size.width, 36.0f);
    
    subtitleLabel.frame = CGRectMake(subtitleLabel.frame.origin.x, subtitleLabel.frame.origin.y, customView.frame.size.width, subtitleLabel.frame.size.height);
    
    [customView addSubview:titleLabel];
    [customView addSubview:subtitleLabel];
    
    //NSLog(@"%@", NSStringFromCGRect(customView.frame));
    
    [self.navigationItem setTitleView:customView];
    
}
-(void)viewDidAppear:(BOOL)animated{
    subtitleLabel.text = [storage objectForKey:@"language_id"];
    [subtitleLabel sizeToFit];
    NSLog(@"%@", [storage objectForKey:@"language_id"]);

}
- (void)options:(id)sender {
    GBOptionsViewController *optionsView = [[GBOptionsViewController alloc] initWithNibName:@"GBOptionsViewController" bundle:nil];
    [optionsView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:optionsView animated:YES completion:nil];
}

- (void)paste:(id)sender {
    NSLog(@"%@", self.textView.text);
    if (self.textView.text != NULL) {
        NSLog(@"uwot");
        NSString *text_format = [self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *post = [NSString stringWithFormat:@"text=%@&expire=10m&lang=%@", text_format, [storage objectForKey:@"language_id"]];
        NSLog(@"%@",post);
        NSString *semiColonFix = [post stringByReplacingOccurrencesOfString:@";" withString:@"%3b"];
        NSData *postData = [semiColonFix dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://ghostbin.com/paste/new"]
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"Ghostbin iOS" forHTTPHeaderField:@"User-Agent"];
        [request setHTTPBody:postData];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }else{
        UIAlertView *oopsAlert = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"You didn't input anything to paste!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [oopsAlert show];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (_responseData) {
        _responseData = nil;
    }
    
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The Ghostbin URL is acquired in connection:willSendRequest:redirectResponse.
    
    if (_responseData) {
        _responseData = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error) {

    }
    
    if (_responseData) {
        _responseData = nil;
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
{
    if (redirectResponse) {
        [connection cancel];
        _uploading = NO;
        
        NSLog(@"%@",[[request URL] copy]);
        UIAlertView *urlAlert = [[UIAlertView alloc] initWithTitle:@"Pasted!" message:[NSString stringWithFormat:@"%@",[[request URL] copy]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [urlAlert show];
        return nil;
    } else {
        return request;
    }
}


@end
