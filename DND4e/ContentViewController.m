//
//  PowerCardViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "ContentViewController.h"
#import "CardView.h"
#import "Data.h"
#import "Utility.h"
#import "UIWebView_Misc.h"

@implementation ContentViewController

@synthesize cardView;
@synthesize thing = _thing;

- (id)initWithThing:(id<DNDHTML>)thing
{
    self = [super initWithNibName:@"ContentViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.thing = thing;
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
    self.title = [self.thing name];
    
    UIColor *barColor = [UIColor blackColor];
    if ([_thing isKindOfClass:[Power class]]) {
        Power *power = (Power*)_thing;
        if ([power.usage isEqualToString:@"At-Will"]) {
            barColor = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
        } else if ([power.usage isEqualToString:@"Encounter"]) {
            barColor =  [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1.0];
        } else if ([power.usage isEqualToString:@"Daily"]) {
            barColor = [UIColor lightGrayColor];
        }
    } else if ([_thing isKindOfClass:[Loot class]]) {
        Loot *loot = (Loot*)_thing;
        if ([[loot items] count] == 1) {
            barColor = [UIColor lightGrayColor];
        } else {
            barColor = [UIColor colorWithRed:0.8 green:0.75 blue:0 alpha:1.0];
        }
    }
    self.navigationController.navigationBar.tintColor = barColor;
        
    
    [self.cardView loadHTMLString:[_thing html] baseURL:[AppData applicationDocumentsDirectory]];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardView.scrollView flashScrollIndicators];
}

#pragma mark - IBActions

- (void) chooseNewWeapon:(UILongPressGestureRecognizer*)hold
{
    if (![self.thing isKindOfClass:[Power class]]) return;
    Power *power = (Power*)_thing;
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
    if (![self.thing isKindOfClass:[Power class]]) return;
    Power *power = (Power*)_thing;
    NSString *internalID = [[power.selected_weapon.has_elements lastObject] internal_id]; // Trying magic item
    NSLog(@"Internal-ID: %@", internalID);
    Loot *loot = [power.character lootForInternalID:internalID];
    if (loot) {
        ContentViewController *pcvc = [[ContentViewController alloc] initWithThing:loot];
        [self.navigationController pushViewController:pcvc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"This isn't the item you're looking for."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void) openAbility:(NSString*)abil
{
    if (![self.thing isKindOfClass:[AbilityScores class]]) return;
    AbilityScores *ability = (AbilityScores*)_thing;
    
    Stat *score = [ability.character.stats objectForKey:abil];
    ContentViewController *vc = [[ContentViewController alloc] initWithThing:score];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) openStatDetail:(NSString*)stat
{
    Stat *score = [[(id)_thing character].stats objectForKey:stat];
    ContentViewController *vc = [[ContentViewController alloc] initWithThing:score];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) openElementDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    RulesElement *element = [[(id)_thing character] elementForCharelem:num];
    ContentViewController *vc = [[ContentViewController alloc] initWithThing:element];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) openItemDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    Loot *loot = [[(id)_thing character] lootForCharelem:num];
    ContentViewController *vc = [[ContentViewController alloc] initWithThing:loot];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIActionSHeet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (![self.thing isKindOfClass:[Power class]]) return;
    Power *power = (Power*)_thing;
    
    NSString *name = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![name isEqualToString:@"Cancel"]) {        
        NSInteger index = [power.has_weapons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            *stop = [name isEqualToString:[obj name]];
            return *stop;
        }];
        if (index == NSNotFound) return;
        Weapon *weapon = [power.has_weapons objectAtIndex:index];
        power.selected_weapon = weapon;
        [self.cardView loadHTMLString:[_thing html] baseURL:[AppData applicationDocumentsDirectory]];
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
    NSString *host = [url host];
    
    NSLog(@"Opening Content with base URL %@", url);
    
    if ([scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    } else if ([scheme isEqualToString:@"change"]) {
        [self chooseNewWeapon:nil];
        return NO;
    } else if ([scheme isEqualToString:@"weapon"]) {
        [self weaponDetail];
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

@end
