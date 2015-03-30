//
//  MySQLKitQuery.h
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2013 Example Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQLKitDatabase.h"
@class MySQLKitResult;


//
//	MySQLKitQuery
//

@interface MySQLKitQuery : NSObject

- (id)initWithDatabase:(MySQLKitDatabase *)database query:(NSString *)query;
- (MySQLKitResult *)execute;

@property (readonly) NSString *queryString;

@end
