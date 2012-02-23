//
//  MainViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *info;

- (id)initWithData:(NSMutableArray*)data;
- (void) openFilePath:(NSString*)path;

- (IBAction)showHelp:(id)sender;

@end
