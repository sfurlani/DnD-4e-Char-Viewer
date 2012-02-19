//
//  BlockActions.h
//  AURTA
//
//  Created by Stephen Furlani on 2/2/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^vblock)();

@interface BlockAction : NSObject 
@property (strong, nonatomic) NSString *label;
@property (copy, nonatomic) vblock action;

+ (id) actionWithLabel:(NSString*)lbl action:(void (^)())action;

@end

@interface BlockAlertView : UIAlertView <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray* actions;

- (id) initWithTitle:(NSString*)title
             message:(NSString*)message
        cancelAction:(BlockAction*)cancel
        otherActions:(BlockAction*)firstAction, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface BlockActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray* actions;

- (id) initWithTitle:(NSString *)title 
   cancelAction:(BlockAction *)cancel 
destructiveAction:(BlockAction *)destructive 
   otherActions:(BlockAction *)firstAction, ...NS_REQUIRES_NIL_TERMINATION;

@end
