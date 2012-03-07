//
//  PageViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"
#import "DetailViewController.h"
#import "PowerDetailViewController.h"
#import "Data.h"
#import "Utility.h"

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
    self.titleLabel.userInteractionEnabled = YES;
    [self.back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
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
    if (self.character)
        self.titleLabel.text = self.character.name;
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

- (void) showDetail:(id<DNDHTML>)item
{
    UIStoryboard *storyboard = nil;
    if (iPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    }
    if (iPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    if (!storyboard) return;
    
    
    if (iPhone) {
        DetailViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
        dvc.item = item;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dvc];
        nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        nav.navigationBarHidden = YES;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    } else if (iPad) {
        PowerDetailViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
        dvc.item = item;
        dvc.character = self.character;
        NSLog(@"dvc: %@", dvc);
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

#pragma mark - IBActions

- (void) back:(id)sender
{
    if (iPhone)
        [self.navigationController popViewControllerAnimated:YES];
    if (iPad) {
        if ([[self.navigationController viewControllers] count] > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
        
}

- (void) home:(id)sender
{
    if (iPhone)
    if (!(self.first != nil) || [self isEqual:self.first]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popToViewController:self.first animated:YES];
    }
    if (iPad)
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
