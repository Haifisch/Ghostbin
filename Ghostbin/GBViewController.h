//
//  GBViewController.h
//  Ghostbin
//
//  Created by James Long on 31/10/2013.
//  Copyright (c) 2013 Evolse Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chromatism/JLTextViewController.h"
#import "GBOptionsViewController.h"

@interface GBViewController : JLTextViewController <NSURLConnectionDelegate>{
    NSMutableData *_responseData;
    NSURLConnection *_connection;
    BOOL _uploading;
    NSUserDefaults *storage;
    UILabel *subtitleLabel;
}
@property(nonatomic, assign, readonly, getter = isUploading) BOOL uploading;

@end
