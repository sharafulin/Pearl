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
//  PearlCCMenuLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlAppDelegate.h"
#import "PearlCCMenuLayer.h"
#import "PearlCCMenuItemSpacer.h"
#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif


@interface PearlCCClickMenu : CCMenu

@end

@interface PearlCCClickMenu (Private)

-(CCMenuItem *) itemForTouch: (UITouch *) touch;

@end

@implementation PearlCCClickMenu

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    BOOL itemTouched = [super ccTouchBegan:touch withEvent:event];
#ifdef PEARL_MEDIA
    if (itemTouched && [self itemForTouch:touch].isEnabled)
        [[PearlAudioController get] clickEffect];
#endif
    
    return itemTouched;
}

@end



@interface PearlCCMenuLayer ()

- (void)doLoad;
- (void)doLayout;

@property (nonatomic, readwrite, retain) CCMenu                                         *menu;

@property (nonatomic, readwrite, assign) BOOL                                           layoutDirty;

@end

@implementation PearlCCMenuLayer

@synthesize items = _items;
@synthesize menu = _menu;
@synthesize logo = _logo;
@synthesize offset = _offset;
@synthesize layout = _layout;
@synthesize layoutDirty = _layoutDirty;
@synthesize delegate = _delegate;
@synthesize itemCounts = _itemCounts;



+ (PearlCCMenuLayer *)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo items:(CCMenuItem *)menuItem, ... {
    
    if (!menuItem)
        [NSException raise:NSInvalidArgumentException
                    format:@"No menu items passed."];
    
    va_list list;
    va_start(list, menuItem);
    CCMenuItem *item;
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:5];
    [menuItems addObject:menuItem];
    
    while ((item = va_arg(list, CCMenuItem*)))
        [menuItems addObject:item];
    va_end(list);
    
    return [self menuWithDelegate:aDelegate logo:aLogo itemsFromArray:[menuItems autorelease]];
}


+ (PearlCCMenuLayer *)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo itemsFromArray:(NSArray *)menuItems {
    
    return [[[self alloc] initWithDelegate:aDelegate logo:aLogo itemsFromArray:menuItems] autorelease];
}


- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:aLogo items:(CCMenuItem *)menuItem, ... {
    
    va_list list;
    va_start(list, menuItem);
    CCMenuItem *item;
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:5];
    [menuItems addObject:menuItem];
    
    while ((item = va_arg(list, CCMenuItem*)))
        [menuItems addObject:item];
    va_end(list);
    
    return [self initWithDelegate:aDelegate logo:aLogo itemsFromArray:[menuItems autorelease]];
}


- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:aLogo itemsFromArray:(NSArray *)menuItems {
    
    if(!(self = [super init]))
        return nil;

    self.delegate           = aDelegate;
    self.logo               = aLogo;
    self.items              = menuItems;
    self.layout             = PearlCCMenuLayoutVertical;
    
    return self;
}


- (void)setItems:(NSArray *)newItems {
    
    [_items release];
    _items = [newItems copy];
    
    [self reset];
}


- (void)setLogo:(CCMenuItem *)aLogo {

    [_logo release];
    _logo = [aLogo retain];
    
    [self reset];
}


- (void)setOffset:(CGPoint)newOffset {

    _offset = newOffset;
    self.menu.position = newOffset;
}


- (void)setLayout:(PearlCCMenuLayout)newLayout {
    
    _layout = newLayout;
    
    [self reset];
}


- (void)onEnter {
    
    [self doLoad];
    
    if (self.layoutDirty) {
        if ([self.delegate respondsToSelector:@selector(didLayout:)])
            [self.delegate didLayout:self];
        self.layoutDirty = NO;
    }
    
    [super onEnter];

    if ([self.delegate respondsToSelector:@selector(didEnter:)])
        [self.delegate didEnter:self];
}


- (void)reset {
    
    if(self.menu) {
        [self.menu removeAllChildrenWithCleanup:NO];
        [self removeChild:self.menu cleanup:YES];
        self.menu = nil;
    }

    [self doLoad];
}


- (void)doLoad {
    
    if (self.menu)
        return;
    
    self.menu = [PearlCCClickMenu menuWithItems:nil];
    self.menu.isRelativeAnchorPoint = YES;
    self.menu.anchorPoint = ccp(-0.5f, -0.5f);
    self.menu.position = self.offset;
    
    if (self.logo)
        [self.menu addChild:self.logo];
    
    [self addChild:self.menu];
    [self doLayout];
    
    if ([self.delegate respondsToSelector:@selector(didLoad:)])
        [self.delegate didLoad:self];
    
    self.layoutDirty = YES;
}

- (void)doLayout {
    
    switch (self.layout) {
        case PearlCCMenuLayoutVertical: {
            for (CCMenuItem *item in self.items)
                [self.menu addChild:item];

            [self.menu alignItemsVertically];
            break;
        }

        case PearlCCMenuLayoutColumns: {
            NSNumber *rows[10] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil };
            NSUInteger r = 0;

            if (self.logo)
                rows[r++] = [NSNumber numberWithUnsignedInt:1];
            
            NSUInteger itemsLeft = [self.items count], i = 0;
            if (itemsLeft % 2)
                [NSException raise:NSInternalInconsistencyException format:@"Item amount must be even for columns layout."];
            
            for (; r < 10 && itemsLeft; r += 2) {
                if (itemsLeft >= 4) {
                    rows[r + 0] = [NSNumber numberWithUnsignedInt:2];
                    rows[r + 1] = [NSNumber numberWithUnsignedInt:2];
                    [self.menu addChild:[self.items objectAtIndex:i + 0]];
                    [self.menu addChild:[self.items objectAtIndex:i + 2]];
                    [self.menu addChild:[self.items objectAtIndex:i + 1]];
                    [self.menu addChild:[self.items objectAtIndex:i + 3]];
                    itemsLeft   -= 4;
                    i           += 4;
                } else {
                    // itemsLeft == 2
                    rows[r + 0] = [NSNumber numberWithUnsignedInt:1];
                    rows[r + 1] = [NSNumber numberWithUnsignedInt:1];
                    [self.menu addChild:[self.items objectAtIndex:i + 0]];
                    [self.menu addChild:[self.items objectAtIndex:i + 1]];
                    itemsLeft   -= 2;
                    i           += 2;
                }
            }

            [self.menu alignItemsInColumns:
             rows[0], rows[1], rows[2], rows[3], rows[4],
             rows[5], rows[6], rows[7], rows[8], rows[9], nil];
            break;
        }
            
        case PearlCCMenuLayoutCustomColumns: {
            NSNumber *cols[10] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil };
            for (NSUInteger c = 0; c < self.itemCounts.count; ++c)
                cols[c] = [self.itemCounts objectAtIndex:c];

            for (CCNode *item in self.items)
                [self.menu addChild:item];
            [self.menu alignItemsInColumns:
             cols[0], cols[1], cols[2], cols[3], cols[4],
             cols[5], cols[6], cols[7], cols[8], cols[9], nil];
            break;
        }
        case PearlCCMenuLayoutCustomRows: {
            NSNumber *rows[10] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil };
            for (NSUInteger r = 0; r < self.itemCounts.count; ++r)
                rows[r] = [self.itemCounts objectAtIndex:r];

            [self.menu alignItemsInColumns:
             rows[0], rows[1], rows[2], rows[3], rows[4],
             rows[5], rows[6], rows[7], rows[8], rows[9], nil];
            break;
        }
        
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Unsupported layout format."];
    }
}


- (void)dealloc {
    
    self.menu = nil;
    
    self.items = nil;
    self.logo = nil;
    self.delegate = nil;

    [super dealloc];
}

@end
