# MySQLKit

MySQLKit is a piece of code for accessing MySQL database from Cocoa.

Written by Kaz Yoshikawa.
Based on 

- Version 0.1

## Status
- Under Development

Some features are functioning but not ready too use.

## Code Usage


```Objective-C
	// CONNECT TO MAMP
	MySQLKitDatabase *database;
	database = [[MySQLKitDatabase alloc] init];
	
	database.socket = @"/Applications/MAMP/tmp/mysql/mysql.sock";
	database.userName = @"root";
	database.password = @"root";
	database.port = 8889;
	[database connect];

	
	// CREATE A DATABASE
	[database executeQueryWithString:@"CREATE DATABASE IF NOT EXISTS MYSQLKIT;"];
	[database executeQueryWithString:@"USE MYSQLKIT;"];
	[database executeQueryWithString:@"DROP TABLE IF EXISTS `Product`;"];
	
	// CREATE A TABLE
	[database executeQueryWithString:@"CREATE TABLE `product_table` ("
				@"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, "
				@"`title` varchar(32), "
				@"`price` decimal(10,2), "
				@"`binary` blob, "
				@"PRIMARY KEY(`ID`)"
				@") ENGINE=InnoDB DEFAULT CHARSET=utf8;"];
	
	// INSERT A ROW
	[database executeQueryWithString:@"INSERT INTO `Product` (`title`, `price`, `binary`) VALUES ('Apple', '120', X'0102030405');"];

	// FETCH SELECTED ROWS
	MySQLKitResult *result = [database executeQueryWithString:@"SELECT * FROM product_table;"];
	for (MySQLKitRow *row in result) {
		NSDictionary *dictionary = row.dictionary;
		NSLog(@"row: %@", dictionary);
	}
```

### MySQLKitDatabase

MySQLKitDatabase represents My SQL database connection.  It has to configure to connect My SQL database and invoke 'connect' method to establish a connection to the database.  

```
- (MySQLKitQuery *)queryWithString:(NSString *)string;
- (MySQLKitQuery *)queryWithFormat:(NSString *)format, ...;
```
These two mothods are to create query object from given SQL string. The created query will not get executed until its 'execute' method is explicitly called.  Created query objects can be kept and reused sometime later.

```
- (MySQLKitResult *)executeQueryWithString:(NSString *)string;
- (MySQLKitResult *)executeQueryWithString:(NSString *)string;
```
These two methods are to create and to execute query object from given string.  It returens 'MySQLKitResult' object and query objects cannot be reused.

### MySQLKitQuery

```
- (MySQLKitResult *)execute;
```
By invoking 'execute' to execute query against the database.  


### MySQLKitResult

```
- (MySQLKitRow *)nextRow;
```

MySQLKitResult represents a result of querying database.  Since it's a subclass of NSEnumerator, you may enumerate rows by following code.

```
	MySQLKitResult *result = ... // select * from table
	for (MySQLKitRow *row in result) {
		NSDictionary *dictionary = row.dictionary;
		NSLog(@"row: %@", dictionary);
	}
```

### MySQLKitRow
MySQLKitRow provides a row in the form of dictionary.

```
@property (readonly) NSDictionary *dictionary;
```

MySQLKitRow provides 'objectForKeyedSubscript:' and 'objectAtIndexedSubscript:' interface, you may access column value by following code.

```
	MySQLKitRow *row = ...
	NSString *name = row[@"name"];
```

```
	MySQLKitRow *row = ...
	NSString *name = row[0];
```

## TO DO LIST
- More Test
- Better BLOB support
- More data type support

## License
GPL, General Public License
