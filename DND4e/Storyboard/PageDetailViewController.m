//
//  PageDetailViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageDetailViewController.h"
#import "ListViewController.h"
#import "PageViewController.h"
#import "Data.h"
#import "Utility.h"
#import "UIWebView_Misc.h"
#import "SlideLeftSegue.h"
#import "SlideRightSegue.h"

@implementation PageDetailViewController

@synthesize webDetail;
@synthesize item;
@synthesize listVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webDetail setShadowHidden:YES];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webDetail addGestureRecognizer:left];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webDetail addGestureRecognizer:right];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLabel.text = [item name];
    [self loadHTML:[item html]];
    NSLog(@"Self.First %@", NSStringFromClass([self.first class]));
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webDetail.scrollView flashScrollIndicators];
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

#pragma mark - IBActions

- (void) openAbility:(NSString*)abil
{
    Stat *score = [self.character.stats objectForKey:abil];
    [self showDetail:score];
}

- (void) openStatDetail:(NSString*)stat
{
    Stat *score = [self.character.stats objectForKey:stat];
    [self showDetail:score];
}

- (void) openElementDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    RulesElement *element = [self.character elementForCharelem:num];
    [self showDetail:element];
}

- (void) openItemDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    Loot *loot = [self.character lootForCharelem:num];
    [self showDetail:loot];
}

#pragma mark - IBAction

- (void) swipeLeft:(UIGestureRecognizer *)gesture
{
    // Next
    if (!self.listVC) return;
    NSArray *items = [self.listVC items];
    NSInteger index = [items indexOfObject:self.item];
    if (index == NSNotFound) return;
    index++;
    if (index <= 0 || index >= [self.listVC.items count]) return;
    id<DNDHTML> new = [items objectAtIndex:index];
    if (!new) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard~iphone" bundle:nil];
    PageDetailViewController *pdvc = [storyboard instantiateViewControllerWithIdentifier:@"pageDetailVC"];
    pdvc.item = new;
    pdvc.listVC = self.listVC;
    pdvc.first = self.first;
    pdvc.character = self.character;
    
    UIStoryboardSegue *segue = [[SlideLeftSegue alloc] initWithIdentifier:nil
                                                                   source:self
                                                              destination:pdvc];
    [segue perform];
}

- (void) swipeRight:(UIGestureRecognizer *)gesture
{
    // Previous
    if (!self.listVC) return;
    NSArray *items = [self.listVC items];
    NSInteger index = [items indexOfObject:self.item];
    if (index == NSNotFound) return;
    index--;
    if (index <= 0 || index >= [self.listVC.items count]) return;
    id<DNDHTML> new = [items objectAtIndex:index];
    if (!new) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard~iphone" bundle:nil];
    PageDetailViewController *pdvc = [storyboard instantiateViewControllerWithIdentifier:@"pageDetailVC"];
    pdvc.item = new;
    pdvc.listVC = self.listVC;
    pdvc.first = self.first;
    pdvc.character = self.character;
    
    UIStoryboardSegue *segue = [[SlideRightSegue alloc] initWithIdentifier:nil
                                                                   source:self
                                                              destination:pdvc];
    [segue perform];
    

}

#pragma mark - UIWebView Delegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    NSString *host = [url host];
    
    NSLog(@"Opening Content with base URL %@", url);
    
    if ([scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    } else if ([scheme isEqualToString:@"element"]) {
        [self openElementDetail:host];
        return NO;
    } else if ([scheme isEqualToString:@"stat"]) {
        [self openStatDetail:[host stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        return NO;
    } else if ([scheme isEqualToString:@"item"]) {
        [self openItemDetail:host];
        return NO;
    } else if ([scheme isEqualToString:@"abil"]) {
        [self openAbility:host];
        return NO;
    }
    
    
    return YES;
}

- (void) loadHTML:(NSString*)string
{
    NSString *html = NSFORMAT(@"<html><body style=\"font-family:Copperplate;background-color:transparent;color:rgba(0,0,0,.8)\">%@</body></html>",string);
    [self.webDetail loadHTMLString:html baseURL:[AppData applicationDocumentsDirectory]];
}

@end
