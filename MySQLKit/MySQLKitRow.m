//
//  MySQLKitRow.m
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import "MySQLKitRow.h"
#import "MySQLKitColumn.h"
#import "MySQLKitResult.h"
#import "mysql.h"


//
//	MySQLKitRow ()
//

@interface MySQLKitRow ()
{
	MySQLKitResult *_result;
	NSDictionary *_dictionary;
	NSArray *_columns;
}

@end




//
//	MySQLKitRow
//

@implementation MySQLKitRow

- (id)initWithResult:(MySQLKitResult *)result dictionary:(NSDictionary *)dictionary columns:(NSArray *)columns
{
	if (self = [super init]) {
		_result = result;
		_dictionary = dictionary;
		_columns = columns;
	}
	return self;
}

- (void)dealloc
{
}

- (NSDictionary *)dictionary
{
	return _dictionary;
}

- (MySQLKitResult *)result
{
	return _result;
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
{
	return _dictionary[key];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	if (index < _columns.count) {
		MySQLKitColumn *column = _columns[index];
		return _dictionary[column.name];
	}
	return nil;
}

@end
