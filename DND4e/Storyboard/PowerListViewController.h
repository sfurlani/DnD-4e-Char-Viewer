//
//  PowerListViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

@interface PowerListViewController : PageViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *powers;
@property (strong, nonatomic) IBOutlet UIButton *sort;
@property (strong, nonatomic) IBOutlet UITableView *powerTable;

@end
