CREATE DATABASE Group_11_FinancialManagementAndBudgeting;

USE Group_11_FinancialManagementAndBudgeting;

CREATE SCHEMA Budgeting;

CREATE TABLE Budgeting.Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
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
	INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
	VALUES ('JohnDoe', @EncryptedPassword, 'John', 'Doe', 'john.doe@example.com', '1990-01-01', 'Software Engineer', 50000.00, '000-00-2222');
	
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

SELECT * FROM Budgeting.Users;

-- Nagalekha 07/04 Adding now

CREATE TABLE Budgeting.Address (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    StreetNumber VARCHAR(50) NOT NULL,
    StreetName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    CONSTRAINT FK_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

-- common function to validate street number and street name
CREATE FUNCTION ValidateStreetNumberOrStreetName (@Street VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the street matches the regular expression pattern
    IF PATINDEX('%[^a-zA-Z0-9\s#\-\/\\.,()]%', @Street) = 0
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- common function to validate city, country and state
CREATE FUNCTION ValidateCityStateCountry (@Name VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    IF @Name LIKE '%[^A-Za-z\s\-''.()]%'
        SET @IsValid = 0;
    ELSE
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- function to validate zipcode
CREATE FUNCTION ValidateZipCode(@ZipCode VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the zip code matches the pattern
    IF @ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' -- Matches pattern "12345"
        OR @ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' -- Matches pattern "12345-6789"
        OR @ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9]' -- Matches pattern "12345 6789"
        SET @IsValid = 1; -- Valid zip code
    ELSE
        SET @IsValid = 0; -- Invalid zip code

    RETURN @IsValid;
END;

-- Add table-level check constraints
ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_StreetNumber CHECK (dbo.ValidateStreetNumberOrStreetName(StreetNumber) = 1);

ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_StreetName CHECK (dbo.ValidateStreetNumberOrStreetName(StreetName) = 1);

ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_City CHECK (dbo.ValidateCityStateCountry(City) = 1);

ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_State CHECK (dbo.ValidateCityStateCountry(State) = 1);

ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_ZipCode CHECK (dbo.ValidateZipCode(ZipCode) = 1);

ALTER TABLE Budgeting.Address
ADD CONSTRAINT CHK_Country CHECK (dbo.ValidateCityStateCountry(Country) = 1);

-- Violating the ValidateStreetNumberOrStreetName check constrain
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES 
(1, '123#', 'MainStreet', 'Springfield', 'ILLINOIS', '12345', 'USA');


-- Create AssetTypes table to hold asset types
CREATE TABLE Budgeting.AssetTypes (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(50) UNIQUE
);

-- Populate AssetTypes table with predefined asset types
INSERT INTO Budgeting.AssetTypes (TypeID, TypeName) VALUES
(1, 'Cash'),
(2, 'Investments'),
(3, 'Real Estate'),
(4, 'Vehicles'),
(5, 'Retirement Accounts'),
(6, 'Business Interests'),
(7, 'Personal Property'),
(8, 'Intellectual Property'),
(9, 'Insurance Policies'),
(10, 'Other Financial Assets');

-- Create Asset table with Type column referencing AssetTypes
CREATE TABLE Budgeting.Asset (
    AssetID INT IDENTITY(1,1),
    EffectiveDate DATE,
    UserID INT,
    TypeID INT,
    Value MONEY,
    AcquisitionDate DATE,
    PRIMARY KEY (AssetID, EffectiveDate),
    FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID),
    FOREIGN KEY (TypeID) REFERENCES Budgeting.AssetTypes(TypeID)
);

-- function to fetch asset type ID given Asset
CREATE FUNCTION GetAssetTypeID (@AssetType VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TypeID INT;

    -- Lookup the TypeID based on the asset type string
    SELECT @TypeID = TypeID
    FROM Budgeting.AssetTypes
    WHERE TypeName = @AssetType;

    RETURN @TypeID;
END;

-- START Insert into Budgeting.Asset

DECLARE @AssetType VARCHAR(100) = 'Cash';
DECLARE @TypeID INT;

-- Get the TypeID for the given asset type
SET @TypeID = dbo.GetAssetTypeID(@AssetType);

-- Now you can use @TypeID in your insert statement to insert into the "Asset" table
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-15', 1, 1000.00, '2024-04-01', @TypeID);

-- END Insert into Budgeting.Asset

CREATE TABLE Budgeting.FinancialInstitutions (
    InstitutionID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    RoutingNumber VARCHAR(20) NOT NULL,
    AddressID INT NOT NULL,
    CONSTRAINT FK_AddressID FOREIGN KEY (AddressID) REFERENCES Budgeting.Address(AddressID)
);

INSERT INTO Budgeting.FinancialInstitutions (Name, RoutingNumber, AddressID)
VALUES ('Santander Bank', '123456789', 4);

CREATE TABLE Budgeting.Accounts (
    AccountNumber INT IDENTITY(1,1),
    InstitutionID INT,
    UserID INT,
    AccountName VARCHAR(100),
    PRIMARY KEY (AccountNumber, InstitutionID),
    CONSTRAINT FK_Accounts_InstitutionID FOREIGN KEY (InstitutionID) REFERENCES Budgeting.FinancialInstitutions(InstitutionID),
    CONSTRAINT FK_Accounts_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

INSERT INTO Budgeting.Accounts (InstitutionID, UserID, AccountName)
VALUES (2, 1, 'Savings Account');

CREATE TABLE Budgeting.Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255)
);

INSERT INTO Budgeting.Category (Name, Description)
VALUES 
    ('Income', 'Including salary, wages, bonuses, and any other sources of income.'),
    ('Housing', 'Expenses related to rent or mortgage payments, property taxes, homeowners or renters insurance, and utilities.'),
    ('Transportation', 'Expenses related to owning and maintaining vehicles, including fuel, maintenance, insurance, and public transportation costs.'),
    ('Food', 'Expenses related to groceries, dining out, and any food-related purchases.'),
    ('Utilities', 'Expenses for electricity, water, gas, internet, and phone services.'),
    ('Debt Payments', 'Including credit card payments, student loan payments, and other debt obligations.'),
    ('Savings', 'Contributions to savings accounts, retirement accounts, emergency funds, or other investment vehicles.'),
    ('Healthcare', 'Expenses for health insurance premiums, medical bills, prescriptions, and other healthcare-related costs.'),
    ('Education', 'Including tuition, fees, and expenses related to furthering education or supporting children''s education.'),
    ('Entertainment', 'Expenses for leisure activities, hobbies, subscriptions, and entertainment services.'),
    ('Personal Care', 'Expenses for personal grooming, hygiene products, and other self-care items.'),
    ('Clothing', 'Expenses for clothing, shoes, and accessories.'),
    ('Gifts and Donations', 'Including gifts for special occasions and charitable donations.'),
    ('Home Maintenance', 'Expenses for home repairs, renovations, and maintenance.'),
    ('Insurance', 'Other insurance premiums such as life insurance, disability insurance, or long-term care insurance.');
   

















