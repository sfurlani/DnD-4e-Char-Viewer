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

#pragma mark - UITAbleView Delegate & Datasource

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


@end
