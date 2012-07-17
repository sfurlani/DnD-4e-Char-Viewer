//
//  ScoresViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface ScoresViewController : PageViewController

@property (strong, nonatomic) IBOutlet UIButton *strDetail;
@property (strong, nonatomic) IBOutlet UIButton *conDetail;
@property (strong, nonatomic) IBOutlet UIButton *dexDetail;
@property (strong, nonatomic) IBOutlet UIButton *intDetail;
@property (strong, nonatomic) IBOutlet UIButton *wisDetail;
@property (strong, nonatomic) IBOutlet UIButton *chaDetail;

@property (strong, nonatomic) IBOutlet UILabel *strScore;
@property (strong, nonatomic) IBOutlet UILabel *conScore;
@property (strong, nonatomic) IBOutlet UILabel *dexScore;
@property (strong, nonatomic) IBOutlet UILabel *intScore;
@property (strong, nonatomic) IBOutlet UILabel *wisScore;
@property (strong, nonatomic) IBOutlet UILabel *chaScore;

@property (strong, nonatomic) IBOutlet UILabel *strMod;
@property (strong, nonatomic) IBOutlet UILabel *conMod;
@property (strong, nonatomic) IBOutlet UILabel *dexMod;
@property (strong, nonatomic) IBOutlet UILabel *intMod;
@property (strong, nonatomic) IBOutlet UILabel *wisMod;
@property (strong, nonatomic) IBOutlet UILabel *chaMod;


- (void) refresh;
- (IBAction)openDetail:(id)sender;
@end
