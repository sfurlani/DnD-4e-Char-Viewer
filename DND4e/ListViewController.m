//
//  ListViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "ListViewController.h"
#import "PageDetailViewController.h"
#import "FileCell.h"
#import "SkillCells.h"
#import "Data.h"
#import "Utility.h"

@implementation ListViewController

@synthesize itemTable, items;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.itemTable indexPathForCell:sender];
        id<DNDHTML> item = [self.items objectAtIndex:[indexPath row]];
        [segue.destinationViewController setItem:item]; 
    }
}

#pragma mark - UITableView Delegate & Datasource


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.items count];
    else
        return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    id<DNDHTML> item = [self.items objectAtIndex:row];
    
    if ([item isKindOfClass:[Skill class]]) {
        Skill *skill = item;
        NSString * kCellIdentifier = @"skillCell";
        if (row%2==0) kCellIdentifier = @"skillCellGray";
        SkillCells *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
        cell.skillTitle.text = skill.name;
        cell.skillValue.text = PFORMAT(skill.bonus);
        return cell;
    } else {
    
        NSString * kCellIdentifier = @"fileCell";
        if (row%2==0) kCellIdentifier = @"fileCellGray";
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
        cell.fileTitle.text = [item name];
        return cell;
    }
}

@end
