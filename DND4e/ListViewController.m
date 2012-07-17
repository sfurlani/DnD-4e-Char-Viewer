//
//  ListViewController.m
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
        [segue.destinationViewController setListVC:self];
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
        if (skill.trained) {
            cell.skillTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:21.0f];
        } else {
            cell.skillTitle.font = [UIFont fontWithName:@"Copperplate-Light" size:21.0f];
        }
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
