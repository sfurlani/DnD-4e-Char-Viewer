//
//  DictionaryExplorerViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DictionaryExplorerViewController : UITableViewController

@property (strong, nonatomic) id data;

- (id)initWithData:(id)data;

@end
