//
//  MainViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back;

- (id)initWithData:(NSArray*)data;
- (void) openFilePath:(NSString*)path;

@end