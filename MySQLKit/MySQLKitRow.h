//
//  MySQLKitRow.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQLKitQuery.h"


//
//	MySQLKitRow
//

@interface MySQLKitRow : NSObject

@property (readonly) NSDictionary *dictionary;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end
