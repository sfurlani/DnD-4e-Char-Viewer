//
//  PageViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

#import "Data.h"

@implementation PageViewController

@synthesize bg, titleLabel, back, first;
@synthesize character = _character;

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
    self.titleLabel.text = self.title;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(home:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.titleLabel addGestureRecognizer:swipe];
    [self.back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
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
    if ([segue.destinationViewController isKindOfClass:[PageViewController class]]) {
        [segue.destinationViewController setFirst:self.first];
        [segue.destinationViewController setCharacter:self.character];
    }
    
}


#pragma mark - IBActions

- (void) back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) home:(id)sender
{
    if (!(self.first != nil) || [self isEqual:self.first]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popToViewController:self.first animated:YES];
    }
}

@end
