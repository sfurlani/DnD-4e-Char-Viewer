//
//  PowerListViewController.m
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

#import "PowerListViewController.h"
#import "PowerDetailViewController.h"
#import "PowerCell.h"
#import "Data.h"
#import "Utility.h"

NSString *const keyPowerSort = @"keyPowerSort";

@implementation PowerListViewController

@synthesize items;
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
    
    self.items = [self.character.powers mutableCopy];
    [self.sort setImage:[UIImage imageNamed:@"sorting"] forState:UIControlStateNormal];
    [self.sort setImage:[UIImage imageNamed:@"sorting_sel"] forState:UIControlStateHighlighted];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *key = [AppDefaults valueForKey:keyPowerSort];
    if (!key) {
        key = @"usage";
        [AppDefaults setObject:key forKey:keyPowerSort];
    }
    [self performSortWithKey:key];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"powerDetail"]) {
        NSIndexPath *indexPath = [self.powerTable indexPathForCell:sender];
        Power *power = [self.items objectAtIndex:[indexPath row]];
        [segue.destinationViewController setItem:power];
        [segue.destinationViewController setListVC:(id)self];
        
    }
    
}

#pragma mark - IBActions

- (void) sort:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Sort the Power List By:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Name",@"Usage",@"Action",@"Attack", nil];
    [sheet showFromRect:[sender frame] inView:self.view animated:YES]; // for iPad
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
    NSString * kCellIdentifier = @"powerCell";
    if (row%2==0) kCellIdentifier = @"powerCellGray";
    
    PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
    id data = [self.items objectAtIndex:row];
    [cell setData:data];
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
        key = @"actionType";
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex+3) {
        key = @"attackType";
    }
    if (!key) return;
    
    [self performSortWithKey:key];
    
}

- (void) performSortWithKey:(NSString*)key
{
    [AppDefaults setObject:key forKey:keyPowerSort];
    [AppDefaults synchronize];
    [self.items sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[Loot class]] &&
            [obj2 isKindOfClass:[Loot class]] ){
            // TODO: fix item sort.
            return [[obj1 magicName] caseInsensitiveCompare:[obj2 magicName]];
        } else if ([obj1 isKindOfClass:[Loot class]]) {
            return NSOrderedDescending;
        } else if ([obj2 isKindOfClass:[Loot class]]) {
            return NSOrderedAscending;
        }
        return [[obj1 valueForKey:key] caseInsensitiveCompare:[obj2 valueForKey:key]];
    }];
    [self.powerTable reloadRowsAtIndexPaths:[self.powerTable indexPathsForVisibleRows]
                           withRowAnimation:UITableViewRowAnimationFade];
}

@end
