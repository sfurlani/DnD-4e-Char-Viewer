//
//  PowerDetailViewController.m
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

#import "PowerDetailViewController.h"
#import "PageViewController.h"
#import "Data.h"
#import "Utility.h"
#import "UIWebView_Misc.h"
#import "SlideLeftSegue.h"
#import "SlideRightSegue.h"

@implementation PowerDetailViewController

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
    if (iPad)
        return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

- (void) chooseNewWeapon:(UILongPressGestureRecognizer*)hold
{
    Power *power = self.item;
    // if not at begining, then the popup gets called a bunch of times
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose New Weapon"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles: nil];
    [power.has_weapons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [sheet addButtonWithTitle:[obj name]];
    }];
    [sheet showInView:self.view];
}

- (void) weaponDetail
{
    Power *power = self.item;
    NSString *internalID = [[power.selected_weapon.has_elements lastObject] internal_id]; // Trying magic item
    NSLog(@"Internal-ID: %@", internalID);
    Loot *loot = [power.character lootForInternalID:internalID];
    if (loot) {
        [self showDetail:loot];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"This isn't the item you're looking for."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - UIWebView Delegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    
    NSLog(@"Opening Content with base URL %@", url);
    
    if ([scheme isEqualToString:@"change"]) {
        [self chooseNewWeapon:nil];
        return NO;
    } else if ([scheme isEqualToString:@"weapon"]) {
        [self weaponDetail];
        return NO;
    }
    
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType] ;
}

#pragma mark - UIActionSHeet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    Power *power = self.item;
    NSString *name = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![name isEqualToString:@"Cancel"]) {        
        NSInteger index = [power.has_weapons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            *stop = [name isEqualToString:[obj name]];
            return *stop;
        }];
        if (index == NSNotFound) return;
        Weapon *weapon = [power.has_weapons objectAtIndex:index];
        power.selected_weapon = weapon;
        [self loadHTML:[power html]];
    }
}


@end
