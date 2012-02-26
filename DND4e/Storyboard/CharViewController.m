//
//  CharViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "CharViewController.h"
#import "PageDetailViewController.h"
#import "ListViewController.h"
#import "Data.h"

@implementation CharViewController

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
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) refresh
{
    self.titleLabel.text = self.character.name;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showCombat"]) {
        [segue.destinationViewController setItem:self.character.scores];
    } else if ([segue.identifier isEqualToString:@"showFeats"]) {
        [segue.destinationViewController setItems:self.character.feats];
    } else if ([segue.identifier isEqualToString:@"showItems"]) {
        [segue.destinationViewController setItems:self.character.loot];
    } else if ([segue.identifier isEqualToString:@"showClass"]) {
        [segue.destinationViewController setItems:self.character.features];
    } else if ([segue.identifier isEqualToString:@"showRace"]) {
        [segue.destinationViewController setItems:self.character.traits];
    } else if ([segue.identifier isEqualToString:@"showDetails"]) {
        [segue.destinationViewController setItem:self.character];
    } else if ([segue.identifier isEqualToString:@"showSkills"]) {
        [segue.destinationViewController setItems:self.character.skills];
    } 
    
    
}

@end
