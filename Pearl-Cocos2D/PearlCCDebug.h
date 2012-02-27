//
//  PearlCCDebug.h
//  Deblock
//
//  Created by Maarten Billemont on 03/04/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCDebug : NSObject {
    
}

+ (void)printStateForScene:(CCScene *)scene;
+ (void)printStateForNode:(CCNode *)node indent:(NSUInteger)indent;
+ (NSString *)describe:(CCNode *)node;

@end