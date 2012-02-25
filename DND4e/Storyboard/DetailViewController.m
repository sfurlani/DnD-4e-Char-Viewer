//
//  DetailViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "UIWebView_Misc.h"

@implementation DetailViewController

@synthesize item = _item;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *html = NSFORMAT(@"%@",[self.item html]);
    [self.webDetail loadHTMLString: baseURL:[AppData applicationDocumentsDirectory]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webDetail.scrollView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) back:(id)sender
{
    if ([[self.navigationController viewControllers] count] == 1) {
        [self dismissModalViewController:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (void) pushNewItem:(id<DNDHTML>)item
{
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

@end
