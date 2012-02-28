//
//  FileViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "FileViewController.h"
#import "PageViewController.h"
#import "CharViewController.h"
#import "MBProgressHUD.h"
#import "FileCell.h"
#import "Utility.h"
#import "iPadViewController.h"

@implementation FileViewController

@synthesize info, bg, titleLabel, fileTable;
@synthesize files = _files;
@synthesize delegate; // iPad-Only

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
    self.bg.image = [UIImage imageNamed:@"bg"];
    self.files = [[AppData files] mutableCopy];
    if (iPhone)
        [AppData setDelegate:self];
    
    // !!!: This should never be over-written at any point.
    self.navigationController.navigationBarHidden = YES;
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
    [self.fileTable reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.fileTable flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openFile"]) {
        [segue.destinationViewController setFirst:segue.destinationViewController];
        NSIndexPath *indexPath = [self.fileTable indexPathForCell:sender];
        NSString *path = [self.files objectAtIndex:[indexPath row]];
        Character *character = [AppData loadCharacterWithFile:path];
        [segue.destinationViewController setCharacter:character]; 
    }
}

#pragma mark - DataFile Delegate

- (void) newData:(NSArray *)files
{
    self.files = [files mutableCopy];
    [self.fileTable reloadData];
}

- (void) openFilePath:(NSString *)path
{
    NSUInteger index = [self.files indexOfObject:path];
    if (index == NSNotFound) {
        NSLog(@"Could not find: %@", path);
        return;
    }
    id cell = [self.fileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) [self performSegueWithIdentifier:@"openFile" sender:cell];
    else NSLog(@"No Cell at index: %d", index);
}


#pragma mark - UITableView Delegate & Datasource


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.files count];
    else
        return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (iPad) {
        NSInteger row = [indexPath row];
        NSString *path = [self.files objectAtIndex:row];
        [self.delegate openFilePath:path];
        [(id)self.delegate dismissPopoverViewController:[(id)self.delegate menu]];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString * kCellIdentifier = @"fileCell";
    if (row%2==0) kCellIdentifier = @"fileCellGray";
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
    NSString *path = [self.files objectAtIndex:row];
    cell.fileTitle.text = [AppData nameFromPath:path];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSString *path = [self.files objectAtIndex:[indexPath row]];
        
        BOOL success = [AppData deleteFileAtPath:path];
        
        if (!success) {
            [tableView setEditing:NO animated:YES];
        } else if (success) {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.files removeObject:path];
            [tableView endUpdates];
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


@end
