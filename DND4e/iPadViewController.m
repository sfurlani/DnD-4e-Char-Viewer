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
#import "SkillCells.h"
#import "PowerCell.h"
#import "FileCell.h"
#import "PowerListViewController.h"
#import "HelpViewController.h"
#import "FileViewController.h"
#import "DetailViewController.h"
#import "PowerDetailViewController.h"

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
@synthesize list;
@synthesize items, itemTable, powers, powerTable, itemHeader, powerHeader;

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
    
    // Initialize Data
    self.list = ltSkill;
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
    [self setOrientation:self.interfaceOrientation duration:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setOrientation:toInterfaceOrientation duration:duration];
    
}

- (void) setOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    /*
     Landscape
     itemHeader = (320,48,352,39)
     itemTable = (320,87,352,661)
     powerHeader = (672,48,352,34)
     powerTable = (672,78,352,670)
     
     Portrait
     itemHeader = (0,620,384,39)
     itemTable = (0,652,384,352)
     powerHeader, (384,48,384,32)
     powerTable = (384,78,384,926)
     
     */
    void (^anim)(void) = nil;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_p"]];
        anim = ^(void) {
            itemHeader.frame = CGRectMake(0,620,384,39);
            itemTable.frame = CGRectMake(0,652,384,352);
            powerHeader.frame = CGRectMake(384,48,384,32);
            powerTable.frame = CGRectMake(384,78,384,926);
        };
    } else {
        anim = ^(void) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_l"]];
            itemHeader.frame = CGRectMake(320,46,352,39);
            itemTable.frame = CGRectMake(320,79,352,670);
            powerHeader.frame = CGRectMake(672,48,352,34);
            powerTable.frame = CGRectMake(672,78,352,670);
        };
    }
    if (!anim) return;
    if (duration > 0) {
        [UIView animateWithDuration:duration
                         animations:anim];
    } else {
        anim();
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Popover Segue dismisss (always)
    [self dismissPopoverViewController:self.popoverSender];
    
    // iOS 5 segue creates many different popovers, one after another.  SIGH.
    // This is a work-around
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) [self prepareForPopoverSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"openFiles"]) {
        [segue.destinationViewController setDelegate:self];
    }
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSString *key = nil;
        // Ability Scores
        if ([sender tag] == 2001) key = keyStrength;
        else if ([sender tag] == 2002) key = keyConstitution;
        else if ([sender tag] == 2003) key = keyDexterity;
        else if ([sender tag] == 2004) key = keyIntelligence;
        else if ([sender tag] == 2005) key = keyWisdom;
        else if ([sender tag] == 2006) key = keyCharisma;
        // Combat Stats
        else if ([sender tag] == 3001) key = @"AC";
        else if ([sender tag] == 3002) key = @"Fortitude Defense";
        else if ([sender tag] == 3003) key = @"Reflex Defense";
        else if ([sender tag] == 3004) key = @"Will Defense";
        else if ([sender tag] == 3005) key = @"Initiative";
        else if ([sender tag] == 3006) key = @"Speed";
        else if ([sender tag] == 3007) key = @"Hit Points";
        else if ([sender tag] == 3008) key = @"Healing Surges";
        else if ([sender tag] == 3009) key = @"Passive Perception";
        else if ([sender tag] == 3010) key = @"Passive Insight";
        PowerDetailViewController *pdvc = [[segue.destinationViewController viewControllers] lastObject];
        id<DNDHTML> item = [self.character.stats objectForKey:key];
        pdvc.character = self.character;
        [pdvc setItem:item];
    }
    
}

#pragma mark - IBActions

- (void) menu:(id)sender
{
    // TODO: pop open file menu
}

- (void) info:(id)sender
{
    // TODO: curl under info
}

- (void) sort:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Sort the Power List By:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Name",@"Usage",@"Action",@"Attack", nil];
    [sheet showFromRect:[sender frame] inView:self.view animated:YES]; // for iPad
}

- (void) openDetail:(id)sender
{
    [self performSegueWithIdentifier:@"showDetail" sender:sender];
}

- (void) selList:(id)sender
{
    ListType old = self.list;
    ListType type = [sender tag];
    if (old == type) return; // don't waste it if they're tapping the same thing again.
    [[self.itemHeader subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]])
            [obj setBackgroundImage:nil forState:UIControlStateNormal];
    }];
    [sender setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
     self.list = type;
    
    UITableViewRowAnimation anim = UITableViewRowAnimationRight;
    if (old < type) anim = UITableViewRowAnimationLeft;
    // No need to do a complete refresh
    [self.itemTable beginUpdates];
     if (self.list == ltSkill) self.items = self.character.skills;
     if (self.list == ltFeat) self.items = self.character.feats;
     if (self.list == ltClass) self.items = self.character.features;
     if (self.list == ltRace) self.items = self.character.traits;
     if (self.list == ltLoot) self.items = self.character.loot;
    [self.itemTable reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:anim];
    [self.itemTable endUpdates];
}

- (void) refresh 
{
    // No loaded character, return.
    if (!self.character) return;
    
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
    self.acValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"AC"] _value]);
    self.reflValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Reflex Defense"] _value]);
    self.fortValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Fortitude Defense"] _value]);
    self.willValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Will Defense"] _value]);
    self.initValue.text = PFORMAT([[self.character.stats objectForKey:@"Initiative"] _value]);
    self.speedValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Speed"] _value]);
    self.hpValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Hit Points"] _value]);
    self.surgeValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Healing Surges"] _value]);
    self.insiValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Passive Insight"] _value]);
    self.percValue.text = NSFORMAT(@"%@",[[self.character.stats objectForKey:@"Passive Perception"] _value]);
    
    self.powers = [self.character.powers mutableCopy];
    [self performSortWithKey:[AppDefaults objectForKey:keyPowerSort]];
    
    if (self.list == ltSkill) self.items = self.character.skills;
    if (self.list == ltFeat) self.items = self.character.feats;
    if (self.list == ltClass) self.items = self.character.features;
    if (self.list == ltRace) self.items = self.character.traits;
    if (self.list == ltLoot) self.items = self.character.loot;
    if (!self.items) { self.list = ltSkill; self.items = self.character.skills; }
    
    [self.powerTable reloadData];
    [self.itemTable reloadData];
}

#pragma mark - DataFileDelegate

- (void) openFilePath:(NSString *)path
{
    self.character = [AppData loadCharacterWithFile:path];
    [self refresh];
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.powerTable]) {
        return [powers count];
    } else {
        return [items count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.powerTable]) {
        return 44.0f;
    } else if (self.list == ltSkill) {
        return 38.0f;
    } else {
        return 44.0f;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<DNDHTML> thing = nil;
    NSInteger row = [indexPath row];
    if ([tableView isEqual:self.powerTable]) {
        thing = [self.powers objectAtIndex:row];
    } else {
        thing = [self.items objectAtIndex:row];
    }
    if (thing) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"detailNavVC"];
        PowerDetailViewController *pdvc = [[nav viewControllers] lastObject];
        if (pdvc) {
            pdvc.item = thing;
            pdvc.character = self.character;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if ([tableView isEqual:self.powerTable]) {
        
        NSString * kCellIdentifier = @"powerCell";
        if (row%2==0) kCellIdentifier = @"powerCellGray";
        
        PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
        id data = [self.powers objectAtIndex:row];
        [cell setData:data];
        return cell;
        
    } else {
        
        id<DNDHTML> item = [self.items objectAtIndex:row];
        
        if ([item isKindOfClass:[Skill class]]) {
            Skill *skill = item;
            NSString * kCellIdentifier = @"skillCell";
            if (row%2==0) kCellIdentifier = @"skillCellGray";
            SkillCells *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
            cell.skillTitle.text = skill.name;
            cell.skillValue.text = PFORMAT(skill.bonus);
            if (skill.trained) {
                cell.skillTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:21.0f];
            } else {
                cell.skillTitle.font = [UIFont fontWithName:@"Copperplate-Light" size:21.0f];
            }
            return cell;
        } else {
            
            NSString * kCellIdentifier = @"itemCell";
            if (row%2==0) kCellIdentifier = @"itemCellGray";
            FileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            NSAssert(cell!=nil, @"Could not find cell with identifier \"%@\"",kCellIdentifier);
            cell.fileTitle.text = [item name];
            return cell;
        }
    }
    
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
    if (key == nil) key = @"name";
    [AppDefaults setObject:key forKey:keyPowerSort];
    [AppDefaults synchronize];
    [self.powers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    [self.powerTable reloadSections:[NSIndexSet indexSetWithIndex:0]
                   withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UIPopover Delegate

#pragma mark - UIPopoverControllerDelegate & Popover Modal Control

@synthesize currentPopover, popoverAction, popoverTarget, popoverSender;

// http://stackoverflow.com/questions/7758837/uistoryboardpopoversegue-opening-multiple-windows-on-button-touch
- (void) prepareForPopoverSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender
{
    /* PREPARE FOR POPOVER SEGUE
     * Problem: iOS 5 Storyboard opens popover after popover when button is clicked on
     * Solution: store action/target, redirect button to "dismiss," restore action/target
     */
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        self.popoverAction = [sender action];
        self.popoverTarget = [sender target];
        [sender setAction:@selector(dismissPopoverViewController:)];
        [sender setTarget:self];
        
    } else if ([sender isKindOfClass:[UIButton class]]) {
        NSParameterAssert([[sender allTargets] count] == 1);
        self.popoverTarget = [[sender allTargets] anyObject];
        NSParameterAssert([[sender actionsForTarget:self.popoverTarget forControlEvent:UIControlEventTouchUpInside] count] == 1);
        self.popoverAction = NSSelectorFromString([[sender actionsForTarget:self.popoverTarget forControlEvent:UIControlEventTouchUpInside] lastObject]);
        [sender removeTarget:self.popoverTarget 
                      action:self.popoverAction
            forControlEvents:UIControlEventTouchUpInside];
        [sender addTarget:self
                   action:@selector(dismissPopoverViewController:)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.currentPopover = segue.popoverController;
    self.currentPopover.delegate = self;
    self.popoverSender = sender;
}

// http://stackoverflow.com/questions/7758837/uistoryboardpopoversegue-opening-multiple-windows-on-button-touch
- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if (self.popoverSender) {
        if ([self.popoverSender isKindOfClass:[UIBarButtonItem class]]) {
            [self.popoverSender setAction:self.popoverAction];
            [self.popoverSender setTarget:self.popoverTarget];
            
        } else if ([self.popoverSender isKindOfClass:[UIButton class]]) {
            [self.popoverSender addTarget:self.popoverTarget 
                                   action:self.popoverAction
                         forControlEvents:UIControlEventTouchUpInside];
            [self.popoverSender removeTarget:self
                                      action:@selector(dismissPopoverViewController:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        self.popoverSender = nil;
    }
    return YES;
}

// http://stackoverflow.com/questions/7758837/uistoryboardpopoversegue-opening-multiple-windows-on-button-touch
- (void) dismissPopoverViewController:(id)sender
{
    if (sender) {
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            [sender setAction:self.popoverAction];
            [sender setTarget:self.popoverTarget];
            
        } else if ([sender isKindOfClass:[UIButton class]]) {
            [sender addTarget:self.popoverTarget 
                       action:self.popoverAction
             forControlEvents:UIControlEventTouchUpInside];
            [sender removeTarget:self
                          action:@selector(dismissPopoverViewController:)
                forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    if (self.currentPopover)
        [self.currentPopover dismissPopoverAnimated:YES];
}


@end
