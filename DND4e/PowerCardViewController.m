//
//  PowerCardViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PowerCardViewController.h"
#import "CardView.h"
#import "Data.h"
#import "Utility.h"
#import "UIWebView_Misc.h"

@implementation PowerCardViewController

@synthesize cardView;
@synthesize power = _power;

- (id)initWithPower:(Power*)power
{
    self = [super initWithNibName:@"PowerCardViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.power = power;
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
    
    UILongPressGestureRecognizer *tapnhold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chooseNewWeapon:)];
    [self.cardView addGestureRecognizer:tapnhold];
    [self.cardView setShadowHidden:YES];
    
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
    [super viewWillAppear:animated];
    self.title = self.power.name;
    
    UIColor *barColor = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    if ([_power.usage isEqualToString:@"Encounter"]) {
        barColor =  [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1.0];
    } else if ([_power.usage isEqualToString:@"Daily"]) {
        barColor = [UIColor lightGrayColor];
    }
    self.navigationController.navigationBar.tintColor = barColor;
    
    [self.cardView loadHTMLString:[_power html] baseURL:[AppData applicationDocumentsDirectory]];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardView.scrollView flashScrollIndicators];
}

#pragma mark - IBActions

- (void) chooseNewWeapon:(UILongPressGestureRecognizer*)hold
{
    // if not at begining, then the popup gets called a bunch of times
    if (/*hold.state == UIGestureRecognizerStateBegan && */ [self.power.has_weapons count] > 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose New Weapon"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles: nil];
        [self.power.has_weapons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [sheet addButtonWithTitle:[obj name]];
        }];
        [sheet showInView:self.view];
    }
}


#pragma mark - UIActionSHeet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *name = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![name isEqualToString:@"Cancel"]) {        
        NSInteger index = [self.power.has_weapons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            *stop = [name isEqualToString:[obj name]];
            return *stop;
        }];
        if (index == NSNotFound) return;
        Weapon *weapon = [self.power.has_weapons objectAtIndex:index];
        self.power.selected_weapon = weapon;
        [self.cardView loadHTMLString:[_power html] baseURL:[AppData applicationDocumentsDirectory]];
    }
}

#pragma mark - UIWEbvIew Delegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    
    if ([scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    } else if ([scheme isEqualToString:@"weapon"]) {
        [self chooseNewWeapon:nil];
        return NO;
    }
    
    return YES;
}

@end
