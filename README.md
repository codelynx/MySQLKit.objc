# MySQLKit

MySQLKit is a piece of code for accessing MySQL database from Cocoa.

Written by Kaz Yoshikawa.
Based on 

- Version 0.1

## Status
- Under Development

Some features are functioning but not ready too use.

## Code Sample


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
	[database executeQuery:@"CREATE DATABASE IF NOT EXISTS MYSQLKIT;"];
	[database executeQuery:@"USE MYSQLKIT;"];
	[database executeQuery:@"DROP TABLE IF EXISTS `Product`;"];
	
	// CREATE A TABLE
	[database executeQuery:@"CREATE TABLE `Product` ("
				@"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, "
				@"`title` varchar(32), "
				@"`price` decimal(10,2), "
				@"`binary` blob, "
				@"PRIMARY KEY(`ID`)"
				@") ENGINE=InnoDB DEFAULT CHARSET=utf8;"];
	
	// INSERT A ROW
	[database executeQuery:@"INSERT INTO `Product` (`title`, `price`, `binary`) VALUES ('Apple', '120', X'0102030405');"];

	// FETCH SELECTED ROWS
	MySQLKitResult *result = [database executeQuery:@"SELECT * FROM PRODUCT;"];
	for (MySQLKitRow *row in result) {
		NSDictionary *dictionary = row.dictionary;
		NSLog(@"row: %@", dictionary);
	}
```



## License
GPL, General Public License
