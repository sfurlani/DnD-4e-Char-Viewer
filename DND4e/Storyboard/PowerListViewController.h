//
//  PowerListViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

extern NSString *const keyPowerSort;

@interface PowerListViewController : PageViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IBOutlet UIButton *sort;
@property (strong, nonatomic) IBOutlet UITableView *powerTable;

- (IBAction) sort:(id)sender;
- (void) performSortWithKey:(NSString*)key;

@end
