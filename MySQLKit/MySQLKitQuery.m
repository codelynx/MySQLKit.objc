//
//	MySQLKitQuery.m
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//	Copyright (c) 2013 Example Inc. All rights reserved.
//

#import "mysql.h"
#import "MySQLKitQuery.h"
#import "MySQLKitDatabase.h"
#import "MySQLKitResult.h"
#import "MySQLKitRow.h"
@class MySQLKitQuery;


//
//	MySQLKitDatabase (accessor)
//

@interface MySQLKitDatabase (accessor)
@property (readonly) MYSQL *mysql;
@property (weak) NSThread *thread;
@end


//
//	MySQLKitResult (init)
//

@interface MySQLKitResult (init)
- (id)initWithQuery:(MySQLKitQuery *)query res:(MYSQL_RES *)res;
@end




//
//	MySQLKitQuery ()
//

@interface MySQLKitQuery ()
{
	MySQLKitDatabase *_database;
	NSString *_queryString;
}

@end


//
//	MySQLKitQuery
//

@implementation MySQLKitQuery

- (id)initWithDatabase:(MySQLKitDatabase*)database query:(NSString *)query;
{
	self = [super init];
	if (self) {
		_database = database;
		_queryString = query;
	}
	return self;
}

- (void)dealloc
{
}

- (MySQLKitResult *)execute
{
	@synchronized (self) {
		
		NSParameterAssert(_database.thread == [NSThread currentThread]);
		if (!mysql_query(_database.mysql, _queryString.UTF8String)) {
			MYSQL_RES *res = mysql_use_result(_database.mysql);
			return [[MySQLKitResult alloc] initWithQuery:self res:res];
		}
		if (mysql_errno(_database.mysql)) {
			NSLog(@"mysql: %@", _database.error);
		}
		return nil;
	}

}

- (NSString *)queryString
{
	return _queryString;
}



@end
