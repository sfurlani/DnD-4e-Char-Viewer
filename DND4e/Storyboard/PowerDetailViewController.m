//
//  PowerDetailViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PowerDetailViewController.h"
#import "PageViewController.h"
#import "Data.h"
#import "Utility.h"
#import "UIWebView_Misc.h"

@implementation PowerDetailViewController

@synthesize power, webPower;

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
    [self.webPower setShadowHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLabel.text = power.name;
    [self loadHTML:[power html]];
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

- (void) chooseNewWeapon:(UILongPressGestureRecognizer*)hold
{
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

#pragma mark - UIActionSHeet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSString *name = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![name isEqualToString:@"Cancel"]) {        
        NSInteger index = [power.has_weapons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            *stop = [name isEqualToString:[obj name]];
            return *stop;
        }];
        if (index == NSNotFound) return;
        Weapon *weapon = [power.has_weapons objectAtIndex:index];
        self.power.selected_weapon = weapon;
        [self loadHTML:[power html]];
    }
}

- (void) loadHTML:(NSString*)string
{
    NSString *html = NSFORMAT(@"<html><body style=\"font-family:Copperplate;background-color:transparent\">%@</body></html>",string);
    [self.webPower loadHTMLString:html baseURL:[AppData applicationDocumentsDirectory]];
}


@end
