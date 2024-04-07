CREATE DATABASE Group_11_FinancialManagementAndBudgeting;

USE Group_11_FinancialManagementAndBudgeting;

CREATE SCHEMA Budgeting;

CREATE TABLE Budgeting.Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL, 
    Password VARBINARY(100) NOT NULL, -- Specify the maximum length of the binary data
    FirstName VARCHAR(50) NOT NULL, 
    LastName VARCHAR(50) NOT NULL, 
    Email VARCHAR(100) NOT NULL, 
    Birthdate DATE, 
    Profession VARCHAR(100), 
    Income DECIMAL(18, 2), 
    SSN VARCHAR(20) 
);


-- Validate UserName
CREATE FUNCTION ValidateUserName (@UserName VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the username contains only alphanumeric characters
    IF @UserName NOT LIKE '%[^a-zA-Z0-9]%' AND LEN(@UserName) >= 3 AND LEN(@UserName) <= 50
        SET @IsValid = 1;

    RETURN @IsValid;
END;



-- Validate Password
CREATE FUNCTION ValidatePassword (@Password VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check for at least one capital letter, one lowercase letter, and special character and  8 < len < 50
    IF @Password LIKE '%[A-Z]%' AND @Password LIKE '%[a-z]%' AND @Password LIKE '%[0-9]%' AND @Password LIKE '%[!@#$%^&*()]%'
    BEGIN
    	IF LEN(@Password) >= 8 AND LEN(@Password) <= 50
    		SET @IsValid = 1;
    END;

    RETURN @IsValid;
END;


-- Define a user-defined function to validate common name fields (FirstName, LastName)
CREATE FUNCTION ValidateName (@Name VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the name contains only characters
    IF @Name NOT LIKE '%[^a-zA-Z]%' AND LEN(@Name) >= 2 AND LEN(@Name) <= 50
        SET @IsValid = 1;

    RETURN @IsValid;
END;


-- Define a user-defined function to validate Email
CREATE FUNCTION ValidateEmail (@Email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Implement email validation logic here
    -- For example, check for valid format, domain, etc.

    IF @Email LIKE '%@%.%' AND LEN(@Email) <= 100 -- Example validation
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- Define a user-defined function to validate SSN
CREATE FUNCTION ValidateSSN (@SSN VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Implement SSN validation logic here
    -- For example, check for valid format, length, etc.

    -- Check if the SSN matches the format AAA-GG-SSSS
    IF @SSN LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- Add table-level check constraints based on the user-defined functions
ALTER TABLE Budgeting.Users
ADD CONSTRAINT CHK_UserName CHECK (dbo.ValidateUserName(UserName) = 1);

ALTER TABLE Budgeting.Users
ADD CONSTRAINT CHK_FirstName CHECK (dbo.ValidateName(FirstName) = 1);

ALTER TABLE Budgeting.Users
ADD CONSTRAINT CHK_LastName CHECK (dbo.ValidateName(LastName) = 1);

ALTER TABLE Budgeting.Users
ADD CONSTRAINT CHK_Email CHECK (dbo.ValidateEmail(Email) = 1);

ALTER TABLE Budgeting.Users
ADD CONSTRAINT CHK_SSN CHECK (dbo.ValidateSSN(SSN) = 1);


/*users password column encryption*/

CREATE MASTER KEY ENCRYPTION BY 
PASSWORD = 'Project@11';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE Project11_Certificate
WITH SUBJECT = 'Project11 Test Certificate',
EXPIRY_DATE = '2024-12-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY Project_SymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Project11_Certificate;


-- START Insert Data into Budgeting.Users
DECLARE @Password VARCHAR(100) = 'ketan711@123'; -- Specify the length of the VARCHAR variable

IF dbo.ValidatePassword(@Password) = 1
BEGIN
	OPEN SYMMETRIC KEY Project_SymmetricKey
	DECRYPTION BY CERTIFICATE Project11_Certificate;

	DECLARE @EncryptedPassword VARBINARY(8000);

	SET @EncryptedPassword = ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), @Password)

	-- Now you can insert the encrypted password into the table
	INSERT INTO Budgeting.Users (UserID, UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
	VALUES (3, 'JohnDoe', @EncryptedPassword, 'John', 'Doe', 'john.doe@example.com', '1990-01-01', 'Software Engineer', 50000.00, '000-00-2222');
	
END

-- END Insert Data into Budgeting.Users


-- START SQL Query to retrieve all data from Budgeting.Users
-- Open the symmetric key for decryption
OPEN SYMMETRIC KEY Project_SymmetricKey DECRYPTION BY CERTIFICATE Project11_Certificate;

-- Retrieve data from the Users table and decrypt the password
SELECT 
    UserID, 
    UserName, 
    CONVERT(VARCHAR(100), DECRYPTBYKEY(Password)) AS Password, 
    FirstName, 
    LastName, 
    Email, 
    Birthdate, 
    Profession, 
    Income, 
    SSN 
FROM 
    Budgeting.Users;

-- Close the symmetric key
CLOSE SYMMETRIC KEY Project_SymmetricKey;

-- END SQL Query to retrieve all data from Budgeting.Users




