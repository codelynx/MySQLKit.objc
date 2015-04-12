//
//  MySQLKitTests.m
//  MySQLKitTests
//
//  Created by Kaz Yoshikawa on 2015/03/24.
//  Copyright (c) 2015 Electricwoods LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MySQLKit.h"

//
//	MySQLKitTests
//

@interface MySQLKitTests : XCTestCase

@property (strong) MySQLKitDatabase *database;

@end

//
//	MySQLKitTests
//

@implementation MySQLKitTests

- (void)setUp
{
    [super setUp];

	self.database = [[MySQLKitDatabase alloc] init];
	
#if 0
	if ([self.database connectWithSocket:@"/Applications/MAMP/tmp/mysql/mysql.sock" username:@"root" password:@"root" database:nil]) {
		[self.database executeQueryWithString:@"CREATE DATABASE IF NOT EXISTS MYSQLKIT;"];
		[self.database reportError];

		[self.database executeQueryWithString:@"USE MYSQLKIT;"];
		[self.database reportError];
		
		[self.database executeQueryWithString:@"DROP TABLE IF EXISTS `product_table`;"];
	}
	else {
		XCTFail(@"Connection failed");
	}
#else
	if ([self.database connectWithHost:@"127.0.0.1" port:8889 username:@"root" password:@"root" database:nil]) {  // "localhost" not working to me [KY]
		[self.database executeQueryWithString:@"CREATE DATABASE IF NOT EXISTS MYSQLKIT;"];
		[self.database reportError];

		[self.database executeQueryWithString:@"USE MYSQLKIT;"];
		[self.database reportError];
		
		[self.database executeQueryWithString:@"DROP TABLE IF EXISTS `product_table`;"];
	}
	else {
		XCTFail(@"Connection failed");
	}
#endif
}

- (void)tearDown
{
    [super tearDown];

	[self.database executeQuery:@"DROP DATABASE MYSQLKIT;"];

	[self.database disconnect];
	self.database = nil;
}

- (void)testBasicCreateTableInsertSelect
{
	NSLog(@"%s (%d)", __FUNCTION__, __LINE__);
	[self.database executeQueryWithString:@"CREATE TABLE `product_table` ("
				@"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, "
				@"`title` varchar(32), "
				@"`price` decimal(10,2), "
				@"`binary` blob, "
				@"PRIMARY KEY(`ID`)"
				@") ENGINE=InnoDB DEFAULT CHARSET=utf8;"];

	[self.database executeQueryWithString:@"INSERT INTO `product_table` (`title`, `price`, `binary`) VALUES ('Apple', '120', X'0102030405');"];
	MySQLKitResult *result = [self.database executeQueryWithString:@"SELECT * FROM `product_table`;"];
	NSArray *rows = result.allObjects;
	XCTAssert(rows.count == 1);
	MySQLKitRow *row = rows.firstObject;
	NSDictionary *dictionary = row.dictionary;
	NSLog(@"dictionary = %@", dictionary);
	XCTAssertEqualObjects(dictionary[@"title"], @"Apple");
	XCTAssertEqualObjects(dictionary[@"price"], [NSDecimalNumber decimalNumberWithString:@"120"]);
	unsigned char buffer[5] = { 0x01, 0x02, 0x03, 0x04, 0x05 };
	XCTAssertEqualObjects(dictionary[@"binary"], [NSData dataWithBytes:buffer length:5]);
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample
{

}

@end
