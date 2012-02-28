//
//  iPadViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/27/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

enum {
    ltSkill = 5000,
    ltFeat,
    ltClass,
    ltRace,
    ltLoot
}; 
typedef NSInteger ListType;

@class Character;

@interface iPadViewController : UIViewController <UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, DataFileDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *strDetail;
@property (strong, nonatomic) IBOutlet UIButton *conDetail;
@property (strong, nonatomic) IBOutlet UIButton *dexDetail;
@property (strong, nonatomic) IBOutlet UIButton *intDetail;
@property (strong, nonatomic) IBOutlet UIButton *wisDetail;
@property (strong, nonatomic) IBOutlet UIButton *chaDetail;

@property (strong, nonatomic) IBOutlet UILabel *strScore;
@property (strong, nonatomic) IBOutlet UILabel *conScore;
@property (strong, nonatomic) IBOutlet UILabel *dexScore;
@property (strong, nonatomic) IBOutlet UILabel *intScore;
@property (strong, nonatomic) IBOutlet UILabel *wisScore;
@property (strong, nonatomic) IBOutlet UILabel *chaScore;

@property (strong, nonatomic) IBOutlet UILabel *strMod;
@property (strong, nonatomic) IBOutlet UILabel *conMod;
@property (strong, nonatomic) IBOutlet UILabel *dexMod;
@property (strong, nonatomic) IBOutlet UILabel *intMod;
@property (strong, nonatomic) IBOutlet UILabel *wisMod;
@property (strong, nonatomic) IBOutlet UILabel *chaMod;

@property (strong, nonatomic) IBOutlet UIButton *acDetail;
@property (strong, nonatomic) IBOutlet UIButton *fortDetail;
@property (strong, nonatomic) IBOutlet UIButton *reflDetail;
@property (strong, nonatomic) IBOutlet UIButton *willDetail;
@property (strong, nonatomic) IBOutlet UIButton *hpDetail;
@property (strong, nonatomic) IBOutlet UIButton *surgeDetail;
@property (strong, nonatomic) IBOutlet UIButton *initDetail;
@property (strong, nonatomic) IBOutlet UIButton *speedDetail;
@property (strong, nonatomic) IBOutlet UIButton *percDetail;
@property (strong, nonatomic) IBOutlet UIButton *insiDetail;

@property (strong, nonatomic) IBOutlet UILabel *acValue;
@property (strong, nonatomic) IBOutlet UILabel *fortValue;
@property (strong, nonatomic) IBOutlet UILabel *reflValue;
@property (strong, nonatomic) IBOutlet UILabel *willValue;
@property (strong, nonatomic) IBOutlet UILabel *hpValue;
@property (strong, nonatomic) IBOutlet UILabel *surgeValue;
@property (strong, nonatomic) IBOutlet UILabel *initValue;
@property (strong, nonatomic) IBOutlet UILabel *speedValue;
@property (strong, nonatomic) IBOutlet UILabel *percValue;
@property (strong, nonatomic) IBOutlet UILabel *insiValue;


@property (strong, nonatomic) IBOutlet UILabel *characterName;
@property (strong, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIButton *sort;

@property (strong, nonatomic) Character *character;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSMutableArray *powers;

@property (strong, nonatomic) IBOutlet UITableView * powerTable;
@property (strong, nonatomic) IBOutlet UITableView * itemTable;

@property (assign, nonatomic) ListType list;

- (IBAction)sort:(id)sender;
- (IBAction)menu:(id)sender;
- (IBAction)info:(id)sender;
- (IBAction)selList:(id)sender;
- (IBAction)openDetail:(id)sender;

- (void) performSortWithKey:(NSString*)key;

- (void) refresh;

#pragma mark - UIPopoverControllerDelegate & Popover Modal Control
@property (strong, nonatomic) UIPopoverController *currentPopover;
@property (assign, nonatomic) SEL popoverAction;
@property (strong, nonatomic) id popoverTarget;
@property (strong, nonatomic) id popoverSender;
- (void) prepareForPopoverSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) dismissPopoverViewController:(id)sender;

- (void) openDetail:(id)sender;

@end
