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
//  UITableView(PearlReloadItems)
//
//  Created by Maarten Billemont on 2014-05-21.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Automatically calculate the necessary section and row animations to update the data in a dataSource.
 *
 * NOTE: This code relies on the row items being unique in terms of -hash and -isEqual.
 */
@interface UITableView(PearlReloadItems)

/**
 * Updates the dataSource collection to become the same as the newSections collection while animating the changes.
 *
 * @param dataSource This should be the collection that is backing your UITableViewDataSource delegate methods.
 * @param newSections A new collection of the same structure as the dataSource.  nil to perform no dataSource changes.
 * @param reloadItems A collection of dataSource items, index paths or sections to reload.  Pass the dataSource itself to reload all items.
 */
- (void)updateDataSource:(NSMutableOrderedSetOrArrayType)dataSource toSections:(NSOrderedSetOrArrayType)newSections
             reloadItems:(NSSetOrArrayType)reloadItems withRowAnimation:(UITableViewRowAnimation)animation;

@end
