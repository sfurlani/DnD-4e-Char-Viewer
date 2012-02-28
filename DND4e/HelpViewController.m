//
//  HelpViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/23/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "HelpViewController.h"
#import "UIWebView_Misc.h"

@implementation HelpViewController

@synthesize appVersion, fileVersion, webHelp;

- (id)init
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webHelp setShadowHidden:YES];
    [self.webHelp setAllBackgroundColors:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    self.fileVersion.text = @"0.07a";
    self.appVersion.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    NSURL *help = [[NSBundle mainBundle] URLForResource:@"help" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:help];
    [self.webHelp loadRequest:request];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}

#pragma mark - IBActions

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) sfg:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://strongfortress.com"];
     [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UIWEbViewDelegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"file"]) {
        return YES;
    }
    if ([scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

@end
