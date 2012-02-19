//
//  UIAlertViewWithBlocks.m
//  AURTA
//
//  Created by Stephen Furlani on 2/2/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "BlockActions.h"

@implementation BlockAction

@synthesize label, action;

+ (id) actionWithLabel:(NSString*)label action:(void (^)())action
{
    BlockAction *avaction = [BlockAction new]; // ARC
    if (avaction) {
        avaction.label = label;
        avaction.action = action;
    }
    return avaction;
}


@end

@implementation BlockAlertView

@synthesize actions;

- (id) initWithTitle:(NSString *)title 
             message:(NSString *)message 
        cancelAction:(BlockAction *)cancel 
        otherActions:(BlockAction *)firstAction, ...
{
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:(cancel ? cancel.label : nil)
              otherButtonTitles:nil];
    if (self) {
        self.actions = [NSMutableArray array];
        va_list args;
        va_start(args, firstAction);
        for (BlockAction *arg = firstAction; arg != nil; arg = va_arg(args, BlockAction*))
        {
            [self.actions addObject:arg];
            [self addButtonWithTitle:arg.label];
        }
        va_end(args);

        if (cancel) {
            [self.actions insertObject:cancel atIndex:0];
        }
        
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    BlockAction *baction = [self.actions objectAtIndex:buttonIndex];
    if (baction) baction.action();
}

@end


@implementation BlockActionSheet

@synthesize actions;

- (id) initWithTitle:(NSString *)title 
        cancelAction:(BlockAction *)cancel
   destructiveAction:(BlockAction *)destructive 
        otherActions:(BlockAction *)firstAction, ...
{
    self = [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:(cancel ? cancel.label : nil)
         destructiveButtonTitle:(destructive ? destructive.label : nil)
              otherButtonTitles:nil];
    if (self) {
        
        self.actions = [NSMutableArray array];
        va_list args;
        va_start(args, firstAction);
        for (BlockAction *arg = firstAction; arg != nil; arg = va_arg(args, BlockAction*))
        {
            [self.actions addObject:arg];
            [self addButtonWithTitle:arg.label];
        }
        va_end(args);
        
        if (cancel) {
            [self.actions insertObject:cancel atIndex:0];
            if (destructive)
                [self.actions insertObject:destructive atIndex:1];
        } else if (destructive) {
            [self.actions insertObject:destructive atIndex:0];
        }
        
        
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BlockAction *baction = [self.actions objectAtIndex:buttonIndex];
    baction.action();
}

@end
