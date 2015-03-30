//
//  MySQLKit.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Based on Matthew Moore on 11/2/13.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for MySQLKit.
FOUNDATION_EXPORT double MySQLKitVersionNumber;

//! Project version string for MySQLKit.
FOUNDATION_EXPORT const unsigned char MySQLKitVersionString[];


// Following headers should not expose may raw mysql structure directory.

#import "MySQLKitDatabase.h"
#import "MySQLKitQuery.h"
#import "MySQLKitResult.h"
#import	"MySQLKitRow.h"
#import "MySQLKitColumn.h"


//
//	MySQLKitDatabase
//

@interface MySQLKit : NSObject
{
}
+ (NSString *)stringFromState:(NSInteger)state;

@end
