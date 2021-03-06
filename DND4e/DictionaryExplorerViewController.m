//
//  DictionaryExplorerViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "DictionaryExplorerViewController.h"
#import "ContentViewController.h"
#import "Utility.h"
#import "Data.h"

#define isArray(obj) [obj isKindOfClass:[NSArray class]]
#define isDictionary(obj) [obj isKindOfClass:[NSDictionary class]]
#define isString(obj) [obj isKindOfClass:[NSString class]]

@implementation DictionaryExplorerViewController

@synthesize data = _data;

- (id)initWithData:(id)data
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.data = data;
        
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if ([[self.data lastObject] isKindOfClass:[Power class]]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (isArray(self.data) || isDictionary(self.data)) {
        return [self.data count];
    } else {
        return 1;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.data lastObject] isKindOfClass:[Power class]]) {
        return 36.0f;
    } else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    id data = nil;
    UITableViewCellAccessoryType acc = UITableViewCellAccessoryDisclosureIndicator;
    NSString *label = nil;
    NSString *detail = nil;
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    if (isArray(self.data)) {
        data = [self.data objectAtIndex:[indexPath row]];
        
        if (isDictionary(data)) {
            label = [data objectForKey:@"name"];
            if ([[data allObjects] count] == 2) {
                detail = [[data allObjects] lastObject];
            }
            
        }
        if (!label) 
            label = [NSString stringWithFormat:@"Object: %d", [indexPath row]];
        
    } else if (isDictionary(self.data)) {
        data = [[self.data allObjects] objectAtIndex:[indexPath row]];
        label = [[self.data allKeys] objectAtIndex:[indexPath row]];
        if (isString(data)) {
            detail = [NSString stringWithFormat:@"%@", data];
        }
        
    } else {
        label = [NSString stringWithFormat:@"%@", data];
    }
    
    if (isDictionary(data)) {
        if ([[data allObjects] count] == 1) {
            detail = [NSString stringWithFormat:@"%@", [[data allObjects] lastObject]];
        }
    }
    
    if ([data conformsToProtocol:@protocol(DNDHTML)]) {
        if ([data isKindOfClass:[Skill class]]) {
            Skill *skill = data;
            detail = (([skill.bonus intValue] > 0) ? NSFORMAT(@"+%@",skill.bonus) : NSFORMAT(@"%@",skill.bonus));
        }
        label = [data name];
    }
    
    if (detail) {
        style = UITableViewCellStyleValue1;
        CellIdentifier = @"hasDetail";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:style 
                                      reuseIdentifier:CellIdentifier];
    }
    
    if ([data isKindOfClass:[Power class]]) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        cell.textLabel.shadowOffset = CGSizeMake(0, -1);
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        acc = UITableViewCellAccessoryNone;
        Power *power = (id)data;
        if ([power.usage rangeOfString:@"At-Will"].length > 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"atwillrow"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"atwillrow"]];
        } else if ([power.usage rangeOfString:@"Encounter"].length > 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"encounterrow"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"encounterrow"]];
        } else if ([power.usage rangeOfString:@"Daily"].length > 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyrow"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyrow"]];
        }
        
        if ([power.attackType rangeOfString:@"Melee"].length > 0 && 
            [power.attackType rangeOfString:@"Ranged"].length > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meleeranged"]];
            
        } else if ([power.attackType rangeOfString:@"Melee"].length > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"melee"]];
        } else if ([power.attackType rangeOfString:@"Ranged"].length > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ranged"]];
        } else if ([power.attackType rangeOfString:@"Close"].length > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
        } else if ([power.attackType rangeOfString:@"Area"].length > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"area"]];
        } else {
            cell.accessoryView = nil;
        }
        if (cell.accessoryView) {
            cell.accessoryView.frame = CGRectInset(cell.accessoryView.frame, -8.0f,1);
            ((UIImageView*)cell.accessoryView).contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
            
    }
    
    // Configure the cell...
    cell.textLabel.text = label;
    if (detail) {
        if (![data isKindOfClass:[Skill class]])
            acc = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = detail;
    }
    cell.accessoryType = acc;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    id data = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (isArray(self.data)) {
        data = [self.data objectAtIndex:[indexPath row]];
    } else if (isDictionary(self.data)) {
        data = [[self.data allObjects] objectAtIndex:[indexPath row]];
    }
    if (isArray(data) || isDictionary(data)) {
        DictionaryExplorerViewController *devc = [[DictionaryExplorerViewController alloc] initWithData:data];
        devc.title = cell.textLabel.text;
        [self.navigationController pushViewController:devc animated:YES];
    } else {
        
        if ([cell.textLabel.text isEqualToString:@"url"]) {
            
            // Open up URL
            UIViewController *uivc = [[UIViewController alloc] init];
            UIWebView *web = [[UIWebView alloc] initWithFrame:uivc.view.frame];
            [uivc.view addSubview:web];
            web.autoresizingMask = uivc.view.autoresizingMask;
            web.scalesPageToFit = YES;
            
            NSURL *url = [NSURL URLWithString:data];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [web loadRequest:request];
            [self.navigationController pushViewController:uivc animated:YES];
            
        }
        
        if ([data conformsToProtocol:@protocol(DNDHTML)]) {
            ContentViewController *pcvc = [[ContentViewController alloc] initWithThing:data];
            [self.navigationController pushViewController:pcvc animated:YES];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
