//
//  ModalStaticSegue.m
//  AURTA
//
//  Created by Stephen Furlani on 1/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "ModalStaticSegue.h"

@implementation ModalStaticSegue

- (void) perform
{
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
    
}

@end
