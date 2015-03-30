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
	
	self.database.socket = @"/Applications/MAMP/tmp/mysql/mysql.sock";
	self.database.userName = @"root";
	self.database.password = @"root";
	self.database.port = 8889;
	XCTAssert(self.database.connect);
	
	[self.database executeQuery:@"CREATE DATABASE IF NOT EXISTS MYSQLKIT;"];
	[self.database reportError];

	[self.database executeQuery:@"USE MYSQLKIT;"];
	[self.database reportError];
	
	[self.database executeQuery:@"DROP TABLE IF EXISTS `Product`;"];
}

- (void)tearDown
{
    [super tearDown];

//	[self.database executeQuery:@"DROP DATABASE MYSQLKIT;"];

	[self.database disconnect];
	self.database = nil;
}

- (void)testBasicCreateTableInsertSelect
{
	NSLog(@"%s (%d)", __FUNCTION__, __LINE__);
	[self.database executeQuery:@"CREATE TABLE `Product` ("
				@"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, "
				@"`title` varchar(32), "
				@"`price` decimal(10,2), "
				@"`binary` blob, "
				@"PRIMARY KEY(`ID`)"
				@") ENGINE=InnoDB DEFAULT CHARSET=utf8;"];

	[self.database executeQuery:@"INSERT INTO `Product` (`title`, `price`, `binary`) VALUES ('Apple', '120', X'0102030405');"];
	MySQLKitResult *result = [self.database executeQuery:@"SELECT * FROM PRODUCT;"];
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
