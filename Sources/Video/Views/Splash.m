/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  Splash.m
//  iLibs
//
//  Created by Maarten Billemont on 09/01/09.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "Splash.h"
#import "AbstractAppDelegate.h"
#import "BarSprite.h"


@interface SplashTransition : ZoomFlipYTransition

@end

@implementation SplashTransition

- (id)initWithGameScene:(Scene *)uiScene {

    if (!(self = [super initWithDuration:[[Config get].transitionDuration floatValue]
                                   scene:uiScene
                             orientation:kOrientationDownOver]))
        return nil;
    
    return self;
}


@end


@interface Splash ()

- (void)switchScene;

@end


@implementation Splash


-(id) init {
    
    if(!(self = [super initWithFile:@"splash.png"]))
        return self;
    
    [self setPosition:ccp([self contentSize].width / 2, [self contentSize].height / 2)];
    
    BarSprite *loadingBar   = [[BarSprite alloc] initWithHead:@"aim.head.png" body:@"aim.body.%d.png" withFrames:16 tail:@"aim.tail.png" animatedTargetting:NO];
    loadingBar.position     = ccp(self.contentSize.width / 2 - 50, 40);
    loadingBar.target       = ccpAdd(loadingBar.position, ccp(100, 0));
    [self addChild:loadingBar];
    [loadingBar release];
    
    switching = NO;
    
    return self;
}


-(void) onEnter {
    
    [super onEnter];
    
    [self switchScene];
    //[self performSelector:@selector(switchScene) withObject:nil afterDelay:2];
}


-(void) switchScene {
    
    @synchronized(self) {
        if(switching)
            return;
        switching = YES;

        Scene *uiScene = [[Scene alloc] init];
        [uiScene addChild:[AbstractAppDelegate get].uiLayer];
        
        // Build a transition scene from the splash scene to the game scene.
        TransitionScene *transitionScene = [[SplashTransition alloc] initWithGameScene:uiScene];
        
        [uiScene release];
        
        // Start the scene and bring up the menu.
        [[Director sharedDirector] replaceScene:transitionScene];
        [transitionScene release];
    }
}


@end
