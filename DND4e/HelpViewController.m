//
//  HelpViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/23/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController

@synthesize appVersion, fileVersion, webHelp;

- (id)init
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)back:(id)sender
{
    [self dismissModalViewController:YES]
}

#pragma mark - UIWEbViewDelegate

@end
