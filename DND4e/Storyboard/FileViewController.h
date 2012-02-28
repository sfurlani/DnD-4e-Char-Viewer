//
//  FileViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface FileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DataFileDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *info;
@property (strong, nonatomic) IBOutlet UITableView *fileTable;

@property (strong, nonatomic) NSMutableArray *files;

// iPad Only
@property (weak, nonatomic) id<DataFileDelegate> delegate;

@end
