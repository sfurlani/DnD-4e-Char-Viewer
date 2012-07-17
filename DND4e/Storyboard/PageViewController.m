//
//  PageViewController.m
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
