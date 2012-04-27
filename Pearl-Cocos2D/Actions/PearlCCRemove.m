/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  PanAction.m
//  Pearl
//
//  Created by Maarten Billemont on 21/02/09.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCRemove.h"


@implementation PearlCCRemove

- (void)startWithTarget:(CCNode *)aTarget {
    
    [super startWithTarget:aTarget];
	[self.target removeFromParentAndCleanup:NO];
}

@end
