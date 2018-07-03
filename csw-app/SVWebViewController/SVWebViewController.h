//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "FlatUIKit.h"

@interface SVWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithPdfData:(NSData*)data;
- (instancetype)initWithBlank;
- (void) loadData:(NSData*)data;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;
@property (nonatomic, strong) NSData *pdfData;
@property (nonatomic, strong) UIActivityIndicatorView *ac;

@end
