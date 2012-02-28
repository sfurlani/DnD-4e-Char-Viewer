//
//  iPadViewController.m
//  DND4e
//
//  Created by Stephen Furlani on 2/27/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "iPadViewController.h"
#import "Data.h"
#import "Utility.h"

enum {
    ltSkill = 0,
    ltFeat,
    ltClass,
    ltRace,
    ltLoot
}; 
typedef NSInteger ListType;

@implementation iPadViewController

@synthesize strDetail, strScore, strMod;
@synthesize conDetail, conScore, conMod;
@synthesize dexDetail, dexScore, dexMod;
@synthesize intDetail, intScore, intMod;
@synthesize wisDetail, wisScore, wisMod;
@synthesize chaDetail, chaScore, chaMod;

@synthesize acDetail, acValue;
@synthesize fortDetail, fortValue;
@synthesize reflDetail, reflValue;
@synthesize willDetail, willValue;
@synthesize hpDetail, hpValue;
@synthesize surgeDetail, surgeValue;
@synthesize initValue, initDetail;
@synthesize insiValue, insiDetail;
@synthesize speedValue, speedDetail;
@synthesize percValue, percDetail;

@synthesize characterName, menu, sort;
@synthesize character;

@synthesize items, itemTable, powers, powerTable;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [AppData setDelegate:self];
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
	return YES;
}

#pragma mark - IBActions

- (void) menu:(id)sender
{
    // TODO: pop open file menu
}

- (void) sort:(id)sender
{
    // TODO sort the list
}

- (void) refresh 
{
    self.characterName.text = self.character.name;
    
    // Ability Scores
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
    
    // Combat Stats
    self.acValue.text = PFORMAT([[self.character.stats objectForKey:@"AC"] _value]);
    self.reflValue.text = PFORMAT([[self.character.stats objectForKey:@"Reflex Defense"] _value]);
    self.fortValue.text = PFORMAT([[self.character.stats objectForKey:@"Fortitude Defense"] _value]);
    self.willValue.text = PFORMAT([[self.character.stats objectForKey:@"Will Defense"] _value]);
    self.initValue.text = PFORMAT([[self.character.stats objectForKey:@"Initiative"] _value]);
    self.speedValue.text = PFORMAT([[self.character.stats objectForKey:@"Speed"] _value]);
    self.hpValue.text = PFORMAT([[self.character.stats objectForKey:@"Hit Points"] _value]);
    self.surgeValue.text = PFORMAT([[self.character.stats objectForKey:@"Healing Surges"] _value]);
    self.insiValue.text = PFORMAT([[self.character.stats objectForKey:@"Passive Insight"] _value]);
    self.percValue.text = PFORMAT([[self.character.stats objectForKey:@"Passive Perception"] _value]);
    
}

@end
