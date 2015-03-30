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
}

@end




//
//	MySQLKitRow
//

@implementation MySQLKitRow

- (id)initWithResult:(MySQLKitResult *)result row:(MYSQL_ROW)row lengths:(unsigned long *)lengths
{
	if (self = [super init]) {
		_result = result;
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		for (MySQLKitColumn *column in _result.columns) {
			NSString *name = column.name;
			NSInteger index = column.index;
			const char *pointer = row[index];
			unsigned long length = lengths[index];
			id value = [column valueFromPointer:pointer length:length];
			[dictionary setValue:value forKey:name];
		}
		_dictionary = dictionary;
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

@end
