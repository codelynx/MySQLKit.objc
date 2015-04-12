//
//  MySQLKitResult.m
//  MySQLKit
//
//  Created by Kaz Yoshikawa on 2015/03/26.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import "mysql.h"
#import "MySQLKitResult.h"
#import "MySQLKitQuery.h"
#import "MySQLKitRow.h"
#import "MySQLKitColumn.h"


//
//	MySQLKitRow (init)
//

@interface MySQLKitRow (init)

- (id)initWithResult:(MySQLKitResult *)result dictionary:(NSDictionary *)dictionary columns:(NSArray *)columns;

@end


//
//	MySQLKitColumn (init)
//

@interface MySQLKitColumn (init)

- (id)initWithResult:(MySQLKitResult *)result field:(MYSQL_FIELD)field index:(NSInteger)index;

@end


//
//	MySQLKitResult ()
//

@interface MySQLKitResult ()
{
	MySQLKitQuery *_query;
	MYSQL_RES *_res;
	NSArray *_columns;
	NSDictionary *_columnDictionary;
}
@property (readonly) NSDictionary *columnDictionary;
@end


//
//	MySQLKitResult
//

@implementation MySQLKitResult

- (id)initWithQuery:(MySQLKitQuery *)query res:(MYSQL_RES *)res
{
	if (self = [super init]) {
		_query = query;
		_res = res;
	}
	return self;
}

- (void)dealloc
{
	if (_res) {
		mysql_free_result(_res), _res = NULL;
	}
}

- (MySQLKitRow *)nextRow
{
	if (_res) {
		MYSQL_ROW row = mysql_fetch_row(_res);
		if (row) {
			unsigned long *lengths = mysql_fetch_lengths(_res);
			NSArray *columns = self.columns;
			NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
			for (MySQLKitColumn *column in columns) {
				NSString *name = column.name;
				NSInteger index = column.index;
				const char *pointer = row[index];
				unsigned long length = lengths[index];
				id value = [column valueFromPointer:pointer length:length];
				[dictionary setValue:value forKey:name];
			}
			mysql_free_result(_res), _res = nil;
			return [[MySQLKitRow alloc] initWithResult:self dictionary:dictionary columns:columns];
		}
	}
	return nil;
}

- (id)nextObject
{
	return [self nextRow];
}

- (NSArray *)columns
{
	if (!_columns) {
		NSMutableArray *columns = [NSMutableArray array];
		if (_res) {
			unsigned int num_fields = mysql_num_fields(_res);
			MYSQL_FIELD *fields = mysql_fetch_fields(_res);
			for (NSInteger i = 0 ; i < num_fields ; i++) {
				MySQLKitColumn *column = [[MySQLKitColumn alloc] initWithResult:self field:fields[i] index:i];
				[columns addObject:column];
			}
		}
		_columns = columns;
	}
	return _columns;
}

- (NSDictionary *)columnDictionary
{
	if (!_columnDictionary) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		if (_res) {
			for (MySQLKitColumn *column in self.columns) {
				NSString *key = column.name;
				[dictionary setValue:column forKey:key];
			}
		}
		_columnDictionary = dictionary;
	}
	return _columnDictionary;
}

- (MySQLKitColumn *)columnWithName:(NSString *)name
{
	return self.columnDictionary[name];
}



@end
