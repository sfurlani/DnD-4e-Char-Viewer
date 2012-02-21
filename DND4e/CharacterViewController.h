//
//  CharacterViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@interface CharacterViewController : UITableViewController

@property (strong, nonatomic) Character * character;
@property (strong, nonatomic) NSDictionary * rows;

- (id) initWithCharacter:(Character*)character;

@end
