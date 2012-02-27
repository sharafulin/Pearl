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
//  PearlLayout.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef PearlLayoutPadding
#define PearlLayoutPadding        5
#endif

/**
 * View layout utility.
 *
 * This is a utility which allows the application to easily build a view programmatically.  Adding views to this layout causes them to get
 * added to a view managed by this utility in a vertical, top-down, manner.
 *
 * When constructed, a view is allocated that is managed by the layout utility and accessible from the view property.  Its frame defaults
 * to the applicationFrame of the main screen.
 */
@interface PearlLayout : NSObject {

@private
    UIScrollView                                        *_scrollView;
    UIView                                              *_contentView;
    UIView                                              *_lastChild;
}


#pragma mark ###############################
#pragma mark Properties

/**
 * The view managed by this layout.
 *
 * This is the view to which all views are added using the add methods.
 */
@property (nonatomic, readonly, retain) UIScrollView    *scrollView;


#pragma mark ###############################
#pragma mark Lifecycle

/** Create a layout with a specific view rather than the default. */
- (id)initWithView:(UIView *)aView;


#pragma mark ###############################
#pragma mark Behaviors

/** Add the brandLogo determined by the application configuration to the layout's view. */
- (PearlLayout *)addLogo;

/** Add the given image as a logo to the layout's view.  Use nil to show the default branding logo. */
- (PearlLayout *)addLogo:(UIImage *)logoData;

/**
 * Add the given view to the layout's view and maximize the given view's location and size in the layout's frame.
 *
 * Adds the given view below the last child and leaves no space below it.
 *
 * @see -addMax:top:minus:usingDefault:
 */
- (PearlLayout *)addMax:(UIView *)newView;
/**
 * Add the given view to the layout's view and maximize the given view's location and size in the layout's frame.
 *
 * Adds the given view using the given top argument as its frame's origin.y component and leaves no space below it.
 *
 * Uses a default value of -1.
 *
 * @see -addMax:top:minus:usingDefault:
 */
- (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top;
/**
 * Add the given view to the layout's view and maximize the given view's location and size in the layout's frame.
 *
 * Adds the given view using the given top argument as its frame's origin.y component and uses the given minus argument as the amount of
 * space to leave open below it.
 *
 * Uses a default value of -1.
 *
 * @see -addMax:top:minus:usingDefault:
 */
 - (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus;
/**
 * Add the given view to the layout's view and maximize the given view's location and size in the layout's frame.
 *
 * The given view's position and size are NOT determined by its frame.  Instead, all components are picked to maximize the given views
 * surface in the layout's frame.
 *
 * @param top           If equal to the default argument, the view is added below the last view added to the layout (some padding added).
 *                      If equal to the default argument and this is the first view being added, the origin.y component is set to 20.
 *                      If not equal to the default argument, the view's origin.y component is set to this argument's value.
 * @param minus         This value determines how much space should be left below the given view when maximizing its height component.
 * @param usingDefault  Only used to compare against the top argument.
 */
- (PearlLayout *)addMax:(UIView *)newView top:(CGFloat)top minus:(CGFloat)minus usingDefault:(CGFloat)d;

/**
 * Add vertical space to the layout, pushing subsequently added children down.
 */
- (PearlLayout *)addSpace:(CGFloat)space;

/**
 * Add the given view to the layout's view using a defaulting value of 0.
 *
 * This method is handy for defaulting all components of views created with a frame that is CGRectZero.
 *
 * @see -add:usingDefault:
 */
- (PearlLayout *)add:(UIView *)newView;
/**
 * Add the given view to the layout's view using the given default value as the value of the given view's frame's components that should be
 * defaulted.
 *
 * The given view's position and size are determined by its frame.
 * Any components of its frame that have a value equal to the default value specified will be replaced by values generated by this layout.
 * The components have the following values generated for them if they are defaulted:
 *  - origin.x:     0
 *  - origin.y:     Below the previous view added (some padding added) or 20 if this is the first view added
 *  - size.width:   The full width of this layout's view
 *  - size.height:  30
 *
 * @param usingDefault  The value that is used to determine which components of the given view's frame should be defaulted.
 */
- (PearlLayout *)add:(UIView *)newView usingDefault:(CGFloat)d;

@end