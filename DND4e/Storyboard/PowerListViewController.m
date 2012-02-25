//
//  PowerListViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PowerListViewController.h"
#import "PowerCell.h"
#import "Data.h"
#import "Utility.h"

@implementation PowerListViewController

@synthesize powers;
@synthesize powerTable, sort;

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
    
    self.powers = [self.character.powers mutableCopy];
    
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

- (void) sort:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Sort the Power List By:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Name",@"Usage",@"Action",@"Attack"];
    [sheet showFromRect:sender.frame inView:self.view animated:YES]; // for iPad
}


#pragma mark - UITableView Delegate & Datasource


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.powers count];
    else
        return 0;
}

static NSString * const kCellIdentifier = @"powerCell";
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
    Power *power = [self.powers objectAtIndex:row];
    [cell setPower:power];
    return cell;
}

#pragma mark - UIActionSheet Delegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *key = nil;
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) { // name
        key = @"name";
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex+1) { //
        key = @"usage";
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex+2) {
        key = @"attackType";
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex+3) {
        key = @"actionType";
    }
    if (!key) return;
    [self.powers sortUsingComparator:(NSComparisonResult ^(id obj1, id obj2)) {
        return [[obj1 valueForKey:key] compare:[obj2 valueForKey:key]];
    }];
    
    
}

@end
