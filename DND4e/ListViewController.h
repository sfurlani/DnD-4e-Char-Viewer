//
//  ListViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

@interface ListViewController : PageViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) IBOutlet UITableView *itemTable;

@end