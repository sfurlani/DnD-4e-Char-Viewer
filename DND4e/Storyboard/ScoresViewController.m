//
//  ScoresViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "ScoresViewController.h"
#import "Data.h"
#import "Utility.h"

@implementation ScoresViewController

@synthesize strDetail, strScore, strMod;
@synthesize conDetail, conScore, conMod;
@synthesize dexDetail, dexScore, dexMod;
@synthesize intDetail, intScore, intMod;
@synthesize wisDetail, wisScore, wisMod;
@synthesize chaDetail, chaScore, chaMod;

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
    AbilityScores *scores = self.character.scores;
    
    self.strScore.text = NSFORMAT(@"%@",[scores score:keyStrength]);
    self.strMod.text = PFORMAT([scores modifier:keyStrength]);
    
    self.conScore.text = NSFORMAT(@"%@",[scores score:keyConstitution]);
    self.conMod.text = PFORMAT([scores modifier:keyConstitution]);
    
    self.dexScore.text = NSFORMAT(@"%@",[scores score:keyDexterity]);
    self.dexMod.text = PFORMAT([scores modifier:keyDexterity]);
    
    self.intScore.text = NSFORMAT(@"%@",[scores score:keyIntelligence]);
    self.intMod.text = PFORMAT([scores modifier:keyIntelligence]);
    
    self.wisScore.text = NSFORMAT(@"%@",[scores score:keyWisdom]);
    self.wisMod.text = PFORMAT([scores modifier:keyWisdom]);
    
    self.chaScore.text = NSFORMAT(@"%@",[scores score:keyCharisma]);
    self.chaMod.text = PFORMAT([scores modifier:keyCharisma]);
    
    [self.strDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.conDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.dexDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.intDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.wisDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.chaDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}

@end
