//
//  PageDetailViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
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
    NSLog(@"HTML: %@", [item html]);
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
    NSLog(@"Element: (%@) %@", elem, element);
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
    // If at Bounds, exit
    if (index <= 0 || index >= [self.listVC.items count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    id<DNDHTML> new = [items objectAtIndex:index];
    if (!new) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
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
    // If at Bounds, exit
    if (index <= 0 || index >= [self.listVC.items count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    id<DNDHTML> new = [items objectAtIndex:index];
    if (!new) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
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
    
    //NSLog(@"Opening Content with base URL %@", url);
    
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
    NSString *html = NSFORMAT(@"<html><body style=\"font-family:Copperplate;background-color:transparent;color:rgba(0,0,0,.8);margin:0;padding:0;font-size:%f\">%@</body></html>",(iPad ? 21.0f : 15.0f),string);
    [self.webDetail loadHTMLString:html baseURL:[AppData applicationDocumentsDirectory]];
}

@end
