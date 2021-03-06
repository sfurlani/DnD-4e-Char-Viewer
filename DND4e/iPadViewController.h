//
//  iPadViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/27/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

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
@property (strong, nonatomic) IBOutlet UIView * itemHeader;
@property (strong, nonatomic) IBOutlet UIView * powerHeader;

@property (assign, nonatomic) ListType list;

- (IBAction)sort:(id)sender;
- (IBAction)menu:(id)sender;
- (IBAction)info:(id)sender;
- (IBAction)selList:(id)sender;
- (IBAction)openDetail:(id)sender;

- (void) performSortWithKey:(NSString*)key;

- (void) refresh;

- (void) setOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

#pragma mark - UIPopoverControllerDelegate & Popover Modal Control
@property (strong, nonatomic) UIPopoverController *currentPopover;
@property (assign, nonatomic) SEL popoverAction;
@property (strong, nonatomic) id popoverTarget;
@property (strong, nonatomic) id popoverSender;
- (void) prepareForPopoverSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) dismissPopoverViewController:(id)sender;

- (void) openDetail:(id)sender;

@end
