//
//  UIAlertViewWithBlocks.m
//  AURTA
//
//  Created by Stephen Furlani on 2/2/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
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
