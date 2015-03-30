//
//  MySQLKitResult.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/26.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MySQLKitRow;
@class MySQLKitColumn;


//
//	MySQLKitResult
//

@interface MySQLKitResult : NSEnumerator

@property (readonly) NSArray *columns;

- (MySQLKitRow *)nextRow;
- (MySQLKitColumn *)columnWithName:(NSString *)name;

@end
