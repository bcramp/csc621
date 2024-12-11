/* ****************************************************************************************
-- These control:
--     the maximum time (in seconds) that the client will wait while trying to establish a
  connection to the MySQL server
--     how long the client will wait for a response from the server once a request has
       been sent over
**************************************************************************************** */
-- SHOW SESSION VARIABLES LIKE '%timeout%';      
-- SET GLOBAL mysqlx_connect_timeout = 600;
-- SET GLOBAL mysqlx_read_timeout = 600;

-- Create the accounts table
-- CREATE TABLE accounts (
--   account_num CHAR(5) PRIMARY KEY,    -- 5-digit account number (e.g., 00001, 00002, ...)
--   branch_name VARCHAR(50),            -- Branch name (e.g., Brighton, Downtown, etc.)
--   balance DECIMAL(10, 2),             -- Account balance, with two decimal places (e.g., 1000.50)
--   account_type VARCHAR(50)            -- Type of the account (e.g., Savings, Checking)
-- );

/* ***************************************************************************************************
The procedure generates a passed in number of records for the accounts table, with the account_num padded to 5 digits.
branch_name is randomly selected from one of the six predefined branches.
balance is generated randomly, between 0 and 100,000, rounded to two decimal places.
***************************************************************************************************** */
-- Change delimiter to allow semicolons inside the procedure
DELIMITER $$

CREATE PROCEDURE generate_accounts(IN num_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE branch_name VARCHAR(50);
    DECLARE account_type VARCHAR(50);
    
    -- Loop to generate num_of_records account records
    WHILE i <= num_of_records DO
        -- Randomly select a branch from the list of branches
        SET branch_name = ELT(FLOOR(1 + (RAND() * 6)), 'Brighton', 'Downtown', 'Mianus', 'Perryridge', 'Redwood', 'RoundHill');
    
        -- Randomly select an account type
        SET account_type = ELT(FLOOR(1 + (RAND() * 2)), 'Savings', 'Checking');
    
        -- Insert account record
        INSERT INTO accounts (account_num, branch_name, balance, account_type)
        VALUES (
            LPAD(i, 5, '0'),                   -- Account number as just digits, padded to 5 digits (e.g., 00001, 00002, ...)
            branch_name,                       -- Randomly selected branch name
            ROUND((RAND() * 100000), 2),       -- Random balance between 0 and 100,000, rounded to 2 decimal places
            account_type                       -- Randomly selected account type (Savings/Checking)
        );

        SET i = i + 1;
    END WHILE;
END$$

-- Reset the delimiter back to the default semicolon
DELIMITER ;

-- Execute the procedure to generate the amount of accounts given the passed in value
CALL generate_accounts(150000); -- Replace with these values 50000, 100000, 150000

-- Clear the values from the table
-- truncate table accounts;


-- ******************************************************************
-- Create Indexes
-- ******************************************************************
-- Show the current indices for the table
SHOW INDEXES from accounts;

-- Creation of indices
ALTER TABLE accounts ADD PRIMARY KEY (account_num); -- Creates the primary key index on account_num
CREATE INDEX idx_branch_name ON accounts (branch_name); -- Creates the branch name index
CREATE INDEX idx_account_type ON accounts (account_type); -- Creates the account type index
CREATE INDEX idx_balance ON accounts (balance); -- Creates the balance index

-- Deletion of indices
ALTER TABLE accounts DROP PRIMARY KEY; -- Deletes the primary key index
DROP INDEX idx_branch_name ON accounts; -- Deletes the branch name index
DROP INDEX idx_account_type ON accounts; -- Deletes the account type index
DROP INDEX idx_balance ON accounts; -- Deletes the balance index


-- ******************************************************************************************
-- Timing analysis
-- ******************************************************************************************
-- Change delimiter to allow semicolons inside the procedure
DELIMITER $$

-- The time_analysis procedure takes in a queryString and returns the average
CREATE PROCEDURE time_analysis(IN queryString TEXT, OUT average DECIMAL(10,2))
BEGIN
    -- Create an iterator
    DECLARE i INT DEFAULT 1;
   
    -- Create a sum value to total the 10 values; set the variable to 0
    DECLARE sum DECIMAL(10,2) DEFAULT 0;
   
    -- Set the query
    SET @sql_query = queryString;
   
    -- Loop to execute the query 10 times
    WHILE i <= 10 DO
        -- Prepare the statement
        PREPARE stmt FROM @sql_query;
            
        -- Capture the start time with microsecond precision (6)
        SET @start_time = NOW(6);

        -- Run the query you want to measure
        EXECUTE stmt;

        -- Capture the end time with microsecond precision
        SET @end_time = NOW(6);
            
        -- Clean up the prepared statement
        DEALLOCATE PREPARE stmt;

        -- Calculate the difference in microseconds and add the difference to the sum
        SET sum = sum + TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time);
            
        -- Increase the iterator
        SET i = i + 1;
    END WHILE;
   
    -- Calculate the average
    SET average = sum / 10.0;
END$$

-- Reset the delimiter back to the default semicolon
DELIMITER ;

-- IMPORTANT: Uncomment which queryString you want to set; either point or range.
-- Point Queries:
-- Point Query 1 is to retrieve accounts from the "Downtown" branch with a balance of exactly $50,000.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE branch_name = 'Downtown' AND balance = 50000";
-- Point Query 2 is to retrieve the number of checking accounts that are from Redwood.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE branch_name = 'Redwood' AND account_type = 'Checking'";
-- Point Query 3 is to retrieve the number of savings accounts that have a balance of exactly $70,000.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE account_type = 'Savings' AND balance = 70000";

-- Range Queries:
-- Range Query 1 to retrieve accounts from the "Downtown" branch with a balance between $10,000 and $50,000.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE branch_name = 'Downtown' AND balance BETWEEN 10000 AND 50000";
-- Range Query 2 to retrieve the number of checking accounts that have a balance between $0 and $30,000.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE account_type = 'Checking' AND balance BETWEEN 0 AND 30000";
-- Range Query 3 to retrieve the number of savings accounts from the "Mianus" branch that have a balance betweeen $55,000 and $91,000.
-- SET @queryString = "SELECT count(*) FROM accounts WHERE account_type = 'Savings' AND branch_name = 'Mianus' AND balance BETWEEN 55000 AND 91000";

-- Default the value of average to 0
SET @average = 0.0;

-- Execute the time analysis procedure, passing in variable @queryString and with return/out variable @average
CALL time_analysis(@queryString, @average);

-- Print the returned average time to complete the 10 queries to the console
SELECT @average;
