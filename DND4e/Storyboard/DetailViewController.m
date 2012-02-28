//
//  DetailViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "UIWebView_Misc.h"
#import "Utility.h"
#import "Data.h"

@implementation DetailViewController

@synthesize item = _item;
@synthesize webDetail, back, titleLabel,bg;

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
    self.bg.image = [UIImage imageNamed:@"bg"];
    [self.back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
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
    
    /*
     <head> <!-- Body tag for Netscape 1 compatibility? lol 
     http://stackoverflow.com/questions/2442727/strange-padding-margin-when-using-uiwebview
     Border on outer for debugging
     -->
     <style type="text/css"> 
     body { margin: 0; padding: 0; background-color:transparent } 
     #outer {border:0px solid #FFFFFF; width:%d px; background-color:transparent}
     #inner {display:table-cell; vertical-align:%@; height:%d px; padding:0px; color:white; background-color:transparent; font-family:helvetica;font-size:%d}
     </style>
     </head>
     
     */
    NSString *html = NSFORMAT(@"<html><body style=\"font-family:Copperplate;background-color:transparent;color:rgba(0,0,0,.8);margin:0;padding:0\"><br><br><br>%@</body></html>",[self.item html]);
    [self.webDetail loadHTMLString:html baseURL:[AppData applicationDocumentsDirectory]];
    self.titleLabel.text = [self.item name];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - IBActions

- (void) chooseNewWeapon:(UILongPressGestureRecognizer*)hold
{
    Power *power = (Power*)_item;
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
    Power *power = (Power*)_item;
    NSString *internalID = [[power.selected_weapon.has_elements lastObject] internal_id]; // Trying magic item
    NSLog(@"Internal-ID: %@", internalID);
    Loot *loot = [power.character lootForInternalID:internalID];
    if (loot) {
        [self pushNewItem:loot];
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
    AbilityScores *ability = (AbilityScores*)_item;
    
    Stat *score = [ability.character.stats objectForKey:abil];
    [self pushNewItem:score];
}

- (void) openStatDetail:(NSString*)stat
{
    Stat *score = [[(id)_item character].stats objectForKey:stat];
    [self pushNewItem:score];
}

- (void) openElementDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    RulesElement *element = [[(id)_item character] elementForCharelem:num];
    [self pushNewItem:element];
}

- (void) openItemDetail:(NSString*)elem
{
    NSNumber *num = NSINT([elem intValue]);
    Loot *loot = [[(id)_item character] lootForCharelem:num];
    [self pushNewItem:loot];
}

- (void) pushNewItem:(id<DNDHTML>)item
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    DetailViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    dvc.item = item;
    [self.navigationController pushViewController:dvc animated:YES];
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
