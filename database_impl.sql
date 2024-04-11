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
DECLARE @Password VARCHAR(100) = 'password@123'; -- Specify the length of the VARCHAR variable

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

SELECT * FROM Budgeting.Users;


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

-- Function to calculate the Age:
CREATE FUNCTION CalculateAge (@Birthdate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    
    SET @Age = DATEDIFF(YEAR, @Birthdate, GETDATE()) -
               CASE
                   WHEN DATEADD(YEAR, DATEDIFF(YEAR, @Birthdate, GETDATE()), @Birthdate) > GETDATE() THEN 1
                   ELSE 0
               END;
    
    RETURN @Age;
END;

-- Find Age of all users
SELECT UserID, FirstName, LastName, Birthdate, dbo.CalculateAge(Birthdate) AS Age
FROM Budgeting.Users;


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

    IF @Name LIKE '%[^A-Za-z\s\-''.() ]%' -- Added space between the brackets
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

-- Insert data into Address Table
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES 
(1, '123#', 'MainStreet', 'Springfield', 'ILLINOIS', '12345', 'USA');


-- Create Types table to hold asset/debt types
CREATE TABLE Budgeting.Types (
    TypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) UNIQUE,
    TypeDescription VARCHAR(255)
);

-- Populate Types table with predefined asset/debt types
INSERT INTO Budgeting.Types (TypeName, TypeDescription) VALUES
('Cash', 'Currency in the form of coins or banknotes.'),
('Investments', 'Financial assets acquired with the expectation of earning a favorable return.'),
('Real Estate', 'Property consisting of land and the buildings on it.'),
('Vehicles', 'Means of transportation such as cars, trucks, motorcycles, etc.'),
('Retirement Accounts', 'Accounts specifically designated for retirement savings, such as 401(k), IRA, etc.'),
('Business Interests', 'Ownership or investments in businesses or companies.'),
('Personal Property', 'Tangible assets owned by an individual, excluding real estate.'),
('Intellectual Property', 'Legal rights over creations of the mind, such as patents, copyrights, and trademarks.'),
('Insurance Policies', 'Contracts that provide financial protection against specified risks.'),
('Other Financial Assets', 'Other types of financial assets not covered by the above categories.');

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
    FOREIGN KEY (TypeID) REFERENCES Budgeting.Types(TypeID)
);

-- function to fetch asset/debt type ID given Asset
CREATE FUNCTION GetTypeID (@Type VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TypeID INT;

    -- Lookup the TypeID based on the asset type string
    SELECT @TypeID = TypeID
    FROM Budgeting.Types
    WHERE TypeName = @Type;

    RETURN @TypeID;
END;

-- START Insert into Budgeting.Asset

DECLARE @Type VARCHAR(100) = 'Cash';
DECLARE @TypeID INT;

-- Get the TypeID for the given asset type
SET @TypeID = dbo.GetTypeID(@Type);

-- Now you can use @TypeID in your insert statement to insert into the "Asset" table
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-15', 1, 1000.00, '2024-04-01', @TypeID);

-- END Insert into Budgeting.Asset

CREATE TABLE Budgeting.Debt (
    DebtID INT PRIMARY KEY IDENTITY(1,1),
    EffectiveDate DATE,
    UserID INT,
    TypeID INT,
    Payment MONEY,
    Principle MONEY,
    OutstandingBalance MONEY,
    InterestRate DECIMAL(5,2),
    DueDate DATE,
    CONSTRAINT FK_Debt_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID),
    CONSTRAINT FK_Debt_TypeID FOREIGN KEY (TypeID) REFERENCES Budgeting.Types(TypeID),
    CONSTRAINT CHK_InterestRate CHECK (InterestRate >= 0)
);

-- START Insert into Budgeting.Debt

DECLARE @Type VARCHAR(100) = 'Real Estate';
DECLARE @TypeID INT;

-- Get the TypeID for the given asset type
SET @TypeID = dbo.GetTypeID(@Type);

-- Now you can use @TypeID in your insert statement to insert into the "Debt" table
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-10', 1, @TypeID, 500.00, 1000.00, 8000.00, 0.05, '2024-05-10');

-- END Insert into Budgeting.Debt

CREATE TABLE Budgeting.FinancialInstitutions (
    InstitutionID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    RoutingNumber VARCHAR(20) NOT NULL,
    AddressID INT NOT NULL,
    CONSTRAINT FK_AddressID FOREIGN KEY (AddressID) REFERENCES Budgeting.Address(AddressID)
);

CREATE FUNCTION ValidateRoutingNumber (@RoutingNumber VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the Routing Number matches the format NNNN-NNNN-N
    IF @RoutingNumber LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9]'
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- Add table-level check constraint for RoutingNumber
ALTER TABLE Budgeting.FinancialInstitutions
ADD CONSTRAINT CHK_RoutingNumber CHECK (dbo.ValidateRoutingNumber(RoutingNumber) = 1);

INSERT INTO Budgeting.FinancialInstitutions (Name, RoutingNumber, AddressID)
VALUES ('Santander Bank', '1234-5678-9', 2);

CREATE TABLE Budgeting.Accounts (
    AccountNumber VARCHAR(20),
    InstitutionID INT,
    UserID INT,
    AccountName VARCHAR(100),
    PRIMARY KEY (AccountNumber, InstitutionID),
    CONSTRAINT FK_Accounts_InstitutionID FOREIGN KEY (InstitutionID) REFERENCES Budgeting.FinancialInstitutions(InstitutionID),
    CONSTRAINT FK_Accounts_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

CREATE FUNCTION ValidateAccountNumber (@AccountNumber VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the account number is between 8 and 12 digits
    IF LEN(@AccountNumber) BETWEEN 8 AND 12 AND @AccountNumber NOT LIKE '%[^0-9]%'
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- Add table-level check constraint for AccountNumber
ALTER TABLE Budgeting.Accounts
ADD CONSTRAINT CHK_AccountNumber CHECK (dbo.ValidateAccountNumber(AccountNumber) = 1);


INSERT INTO Budgeting.Accounts (AccountNumber, InstitutionID, UserID, AccountName)
VALUES ('123456789', 5, 1, 'Savings Account');

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
   
   
CREATE TABLE Budgeting.Budget (
    BudgetID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    CategoryID INT,
    Amount MONEY,
    StartDate DATE,
    EndDate DATE,
    CONSTRAINT FK_Budget_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID),
    CONSTRAINT FK_Budget_CategoryID FOREIGN KEY (CategoryID) REFERENCES Budgeting.Category(CategoryID)
);

CREATE FUNCTION ValidateDates(@StartDate DATE, @EndDate DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    IF @StartDate < @EndDate
        SET @IsValid = 1; -- Valid dates
    ELSE
        SET @IsValid = 0; -- Invalid dates

    RETURN @IsValid;
END;

ALTER TABLE Budgeting.Budget
ADD CONSTRAINT CHK_StartDateBeforeEndDate CHECK (dbo.ValidateDates(StartDate, EndDate) = 1);

-- violates CHK_StartDateBeforeEndDate, since startDate > EndDate
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (1, 4, 500.00, '2024-03-01', '2024-01-30');

-- should work
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (1, 4, 500.00, '2024-03-01', '2024-04-30');

CREATE TABLE Budgeting.Inflow (
    InflowID INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20),
    InstitutionID INT,
    Amount MONEY,
    Description VARCHAR(100),
    Date DATE,
    CategoryID INT,
    CONSTRAINT FK_Inflow_AccountID FOREIGN KEY (AccountNumber, InstitutionID) REFERENCES Budgeting.Accounts(AccountNumber, InstitutionID),
    CONSTRAINT FK_Inflow_CategoryID FOREIGN KEY (CategoryID) REFERENCES Budgeting.Category(CategoryID)
);

INSERT INTO Budgeting.Inflow (AccountNumber, InstitutionID, Amount, Date, CategoryID)
VALUES ('123456789', 5, 1000.00, '2024-04-10', 1);

CREATE TABLE Budgeting.Outflow (
    OutflowID INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20),
    InstitutionID INT,
    Description VARCHAR(100),
    Amount MONEY,
    Date DATE,
    CategoryID INT,
    CONSTRAINT FK_Outflow_AccountID FOREIGN KEY (AccountNumber, InstitutionID) REFERENCES Budgeting.Accounts(AccountNumber, InstitutionID),
    CONSTRAINT FK_Outflow_CategoryID FOREIGN KEY (CategoryID) REFERENCES Budgeting.Category(CategoryID)
);

INSERT INTO Budgeting.Outflow (AccountNumber, InstitutionID, Amount, Date, CategoryID)
VALUES ('123456789', 5, 1000.00, '2024-04-10', 1);

CREATE TABLE Budgeting.Goals (
    GoalID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Description VARCHAR(255),
    TargetAmount MONEY,
    CurrentAmount MONEY DEFAULT 0.0,
    TargetDate DATE,
    Status VARCHAR(30),
    CONSTRAINT FK_Goals_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

-- accepted values for status are 'IN_PROGRESS', 'COMPLETED' 
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (1, 'Save for vacation', 2000.00, '2024-12-31', 'IN_PROGRESS');

-- Budgeting is an audit table, so whenever a subscription plan is availed by the user, 
-- the Bills must be generated accordingly
-- TODO: Write a trigger to generate the Bills when A new plan is availed by the User
CREATE TABLE Budgeting.Bills (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    BillingDate DATE,
    Amount MONEY,
    PaymentStatus VARCHAR(50),
    CONSTRAINT FK_Bills_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

CREATE TABLE Budgeting.SubscriptionPlan (
    PlanID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    CostPerPeriod MONEY,
    BillingFrequency INT
);

-- Inserting the Annual Plan
INSERT INTO Budgeting.SubscriptionPlan (ProductName, CostPerPeriod, BillingFrequency)
VALUES ('Annual Plan', 120.00, 1);

-- Inserting the Monthly Plan
INSERT INTO Budgeting.SubscriptionPlan (ProductName, CostPerPeriod, BillingFrequency)
VALUES ('Monthly Plan', 10.00, 12);

-- Inserting the Weekly Plan
INSERT INTO Budgeting.SubscriptionPlan (ProductName, CostPerPeriod, BillingFrequency)
VALUES ('Weekly Plan', 10.00, 1);

-- TODO: Subscription End Date, Billing Frequency, Status need to be calculated on INSERT
-- TODO: None of the Start Date - End Date must overlap
CREATE TABLE Budgeting.SubscriptionPlanUserMap (
    PlanID INT,
    UserID INT,
    SubscriptionStartDate DATE,
    SubscriptionEndDate DATE,
    Status VARCHAR(50),
    PRIMARY KEY (PlanID, UserID, SubscriptionStartDate),
    FOREIGN KEY (PlanID) REFERENCES Budgeting.SubscriptionPlan(PlanID),
    FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID)
);

INSERT INTO Budgeting.SubscriptionPlanUserMap (PlanID, UserID, SubscriptionStartDate)
VALUES 
    (1, 1, '2024-04-01'), -- adding Annual plan
    (2, 1, '2025-04-01'); -- adding Monthly plan

    
-- accepted values for PaymentType: 'DEBIT'/'CREDIT'
CREATE TABLE Budgeting.PaymentMethod (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CardNumber VARCHAR(20),
    PaymentType VARCHAR(100),
    CardHolderName VARCHAR(100),
    ExpiryDate DATE,
    SecurityCode VARCHAR(10),
    IssuingBank VARCHAR(100),
    CreditLimit MONEY,
    BillingAddressID INT,
    CONSTRAINT FK_PaymentMethod_UserID FOREIGN KEY (UserID) REFERENCES Budgeting.Users(UserID),
    CONSTRAINT FK_PaymentMethod_BillingAddressID FOREIGN KEY (BillingAddressID) REFERENCES Budgeting.Address(AddressID)
);

-- Validate SecurityCode
CREATE FUNCTION ValidateSecurityCode (@SecurityCode VARCHAR(10))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the security code matches the regular expression pattern
    IF @SecurityCode LIKE '[0-9][0-9][0-9][0-9]' OR @SecurityCode LIKE '[0-9][0-9][0-9]'
        SET @IsValid = 1;

    RETURN @IsValid;
END;

-- Validate Card Number
ALTER FUNCTION ValidateCardNumber (@CardNumber VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the card number is between 14 and 16 digits
    IF LEN(@CardNumber) BETWEEN 14 AND 16 AND @CardNumber NOT LIKE '%[^0-9]%'
        SET @IsValid = 1;

    RETURN @IsValid;
END;

ALTER TABLE Budgeting.PaymentMethod
ADD CONSTRAINT CHK_ValidSecurityCode CHECK (dbo.ValidateSecurityCode(SecurityCode) = 1);

ALTER TABLE Budgeting.PaymentMethod
ADD CONSTRAINT CHK_ValidCardNumber CHECK (dbo.ValidateCardNumber(CardNumber) = 1);


-- Inserting a CREDIT card payment method
INSERT INTO Budgeting.PaymentMethod (UserID, CardNumber, PaymentType, CardHolderName, ExpiryDate, SecurityCode, IssuingBank, CreditLimit, BillingAddressID)
VALUES (1, '371234567890123', 'CREDIT', 'John Doe', '2025-12-31', '123', 'Bank of America', 1000.00, 2);

CREATE TABLE Budgeting.Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE,
    Amount MONEY,
    PaymentMethodID INT,
    CONSTRAINT FK_Payments_PaymentMethodID FOREIGN KEY (PaymentMethodID) REFERENCES Budgeting.PaymentMethod(PaymentMethodID)
);

CREATE TRIGGER UpdateBillingStatus
ON Budgeting.Payments
AFTER INSERT
AS
BEGIN
    UPDATE Budgeting.Bills
    SET PaymentStatus = 'Paid'
    WHERE BillID IN (SELECT BillID FROM inserted);
END;

-- TODO: When a payment is made (new row is inserted) we need to make sure that we 
-- check whether Payments.PaymentDate < PaymentMethod.ExpiryDate
-- WHERE Payments.PaymentMethodID == PaymentMethod.PaymentMethodID

CREATE FUNCTION ValidatePaymentAmount (@PaymentID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;
    DECLARE @BillAmount MONEY;

    SELECT @BillAmount = b.Amount
    FROM Budgeting.Bills b
    INNER JOIN inserted i ON b.UserID = i.UserID
    WHERE b.PaymentStatus = 'Unpaid'
    ORDER BY b.BillingDate DESC;

    IF @BillAmount IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE PaymentID = @PaymentID AND Amount = @BillAmount)
            SET @IsValid = 1;
    END;
    
    RETURN @IsValid;
END;

-- Alter the Payments table to add a CHECK constraint
ALTER TABLE Budgeting.Payments
ADD CONSTRAINT CHK_ValidPaymentAmount 
CHECK (dbo.ValidatePaymentAmount(PaymentID) = 1);


------ Initiate first bill trigger
CREATE TRIGGER GenerateBillOnSubscription
ON Budgeting.SubscriptionPlanUserMap
AFTER INSERT
AS
BEGIN
    -- Insert a new row into the Bills table for each new subscription plan availed by the user
    INSERT INTO Budgeting.Bills (UserID, BillingDate, Amount, PaymentStatus)
    SELECT 
        i.UserID,
        GETDATE() AS BillingDate,
        sp.CostPerPeriod AS Amount,
        'Unpaid' AS PaymentStatus
    FROM 
        inserted i
    INNER JOIN 
        Budgeting.SubscriptionPlan sp ON i.PlanID = sp.PlanID;
END;



---Views

CREATE VIEW Budgeting.BudgetSummary AS
SELECT 
    b.UserID,
    MONTH(i.Date) AS [Month],
    b.Amount AS BudgetAmount,
    SUM(CASE WHEN t.Type = 'Inflow' THEN i.Amount ELSE 0 END) AS CurrentInflows,
    SUM(CASE WHEN t.Type = 'Outflow' THEN o.Amount ELSE 0 END) AS CurrentOutflows,
    b.Amount - SUM(CASE WHEN t.Type = 'Outflow' THEN o.Amount ELSE 0 END) AS RemainingAmount
FROM Budgeting.Budget b
LEFT JOIN Budgeting.Inflow i ON b.CategoryID = i.CategoryID
LEFT JOIN Budgeting.Outflow o ON b.CategoryID = o.CategoryID
CROSS APPLY (VALUES ('Inflow'), ('Outflow')) AS t(Type)
GROUP BY b.UserID, MONTH(i.Date), b.Amount;

---------- User Financial Overview --- 
CREATE VIEW UserFinancialOverview AS
SELECT 
    u.UserID,
    u.FirstName,
    u.LastName,
    u.Email,
    u.Income,
    SUM(i.Amount) AS TotalInflows,
    SUM(o.Amount) AS TotalOutflows,
    (SUM(i.Amount) - SUM(o.Amount)) AS NetCashFlow,
    (SELECT SUM(Value) FROM Budgeting.Asset WHERE UserID = u.UserID) AS TotalAssets,
    (SELECT SUM(d.outstandingBalance) FROM Budgeting.Debt d WHERE d.UserID = d.UserID) AS TotalLiabilities,
    ((SELECT SUM(Value) FROM Budgeting.Asset WHERE UserID = u.UserID) - (SELECT SUM(d.OutstandingBalance) FROM Budgeting.Debt d WHERE d.UserID = d.UserID)) AS NetWorth
FROM 
    Budgeting.Users u
LEFT JOIN Budgeting.Accounts a on u.userId = a.UserId
LEFT JOIN 
    Budgeting.Inflow i ON a.accountNumber = i.accountNumber
LEFT JOIN 
    Budgeting.Outflow o ON a.accountNumber = o.accountNumber
GROUP BY 
    u.UserID, u.FirstName, u.LastName, u.Email, u.Income;
   
   ----Monthly Budget Performance View---
   CREATE VIEW MonthlyBudgetPerformance AS
SELECT 
    b.UserID,
    MONTH(o.Date) AS Month,
    b.CategoryID,
    c.Name AS CategoryName,
    b.Amount AS BudgetAmount,
    SUM(o.Amount) AS ActualAmount,
    (b.Amount - SUM(o.Amount)) AS Variance
FROM 
    Budgeting.Budget b
LEFT JOIN 
    Budgeting.Outflow o ON b.CategoryID = o.CategoryID
LEFT JOIN 
    Budgeting.Category c ON b.CategoryID = c.CategoryID
GROUP BY 
    b.UserID, MONTH(o.Date), b.CategoryID, c.Name, b.Amount;

   --- Asset Allocation View --- 
CREATE VIEW AssetAllocation AS
SELECT 
    a.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    a.TypeID,
    at.TypeName,
    SUM(Value) AS TotalValue,
    SUM(Value) / (SELECT SUM(Value) FROM Budgeting.Asset WHERE UserID = a.UserID) AS Percentage
FROM 
    Budgeting.Asset a
JOIN 
    Budgeting.Types at ON a.TypeID = at.TypeID
  LEFT JOIN Budgeting.Users u on u.userID = a.UserId
GROUP BY 
    a.UserID, u.FirstName, u.LastName, a.TypeID, at.TypeName;

---- Debt allocation view --- 
CREATE VIEW DebtOverview AS
SELECT 
    d.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    SUM(d.OutstandingBalance) AS TotalDebt,
    AVG(d.Payment) AS AverageMonthlyPayment,
    SUM(d.OutstandingBalance) / (SELECT Income FROM Budgeting.Users WHERE UserID = d.UserID) AS DebtToIncomeRatio
FROM 
    Budgeting.Debt d
    LEFT JOIN Budgeting.Users u on u.userID = d.UserId
GROUP BY 
    d.UserID, u.FirstName, u.LastName;

   
---Financial Goals View -- 
   CREATE VIEW FinancialGoalProgress AS
SELECT 
    g.UserID,
    g.GoalID,
    g.Description,
    g.TargetAmount,
    g.CurrentAmount,
    g.TargetDate,
    CASE 
        WHEN g.Status = 'COMPLETED' THEN 'Completed'
        WHEN g.TargetDate < GETDATE() THEN 'Overdue'
        ELSE 'In Progress'
    END AS Status
FROM 
    Budgeting.Goals g;

----Transaction History View----
CREATE VIEW TransactionHistory AS
SELECT 
    u.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    'Inflow' AS TransactionType,
    i.AccountNumber,
    fi.Name as InstitutionName,
    Amount,
    Date
FROM 
    Budgeting.Inflow i
    LEFT JOIN Budgeting.Accounts a on a.AccountNumber = i.AccountNumber
    LEFT JOIN Budgeting.Users u on u.userID = a.UserId
    LEFT JOIN Budgeting.FinancialInstitutions fi  on i.InstitutionId = fi.InstitutionId
UNION ALL
SELECT 
    u.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    'Outflow' AS TransactionType,
    o.AccountNumber,
    fi.Name as InstitutionName,
    Amount,
    Date
FROM 
    Budgeting.Outflow o
    LEFT JOIN Budgeting.Accounts a on o.AccountNumber = a.AccountNumber
    LEFT JOIN Budgeting.Users u on u.userID = a.UserId
    LEFT JOIN Budgeting.FinancialInstitutions fi  on o.InstitutionId = fi.InstitutionId 

----Budget Category Breakdown view ----
   CREATE VIEW BudgetCategoryBreakdown AS
SELECT 
    u.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    c.Name AS CategoryName,
    SUM(o.Amount) AS TotalAmount
FROM 
    Budgeting.Outflow o
JOIN Budgeting.Category c ON o.CategoryID = c.CategoryID
LEFT JOIN Budgeting.Accounts a on o.AccountNumber = a.AccountNumber
LEFT JOIN Budgeting.Users u on u.userID = a.UserId
GROUP BY 
   u.UserID, u.FirstName, u.LastName, c.Name;

 ----Income and Expense Trend Analysis View--
   CREATE VIEW IncomeExpenseTrendAnalysis AS
SELECT 
    u.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    DATENAME(MONTH,i.date) AS Month,
    'Inflow' AS TransactionType,
    SUM(Amount) AS TotalAmount
FROM 
    Budgeting.Inflow i
    LEFT JOIN Budgeting.Accounts a on a.AccountNumber = i.AccountNumber
    LEFT JOIN Budgeting.Users u on u.userID = a.UserId
GROUP BY 
    u.UserID,u.FirstName, u.LastName, DATENAME(MONTH,i.date)
UNION ALL
SELECT 
    u.UserID,
    Concat(u.FirstName,' ',u.LastName) as UserName,
    DATENAME(MONTH,o.date) AS Month,
    'Outflow' AS TransactionType,
    SUM(Amount) AS TotalAmount
FROM 
    Budgeting.Outflow o
    LEFT JOIN Budgeting.Accounts a on a.AccountNumber = o.AccountNumber
    LEFT JOIN Budgeting.Users u on u.userID = a.UserId
GROUP BY 
     u.UserID,u.FirstName, u.LastName, DATENAME(MONTH,o.date);

 -----Financial Health Score View----
  CREATE VIEW FinancialHealthScore AS
SELECT 
    UserID,
    UserName,
    CASE 
        WHEN DebtToIncomeRatio <= 0.3 AND SavingsRate >= 0.2 THEN 'Excellent'
        WHEN DebtToIncomeRatio <= 0.4 AND SavingsRate >= 0.1 THEN 'Good'
        WHEN DebtToIncomeRatio <= 0.5 AND SavingsRate >= 0.05 THEN 'Fair'
        ELSE 'Poor'
    END AS HealthScore
FROM 
    (SELECT 
        d.UserID,
        Concat(u.FirstName,' ',u.LastName) as UserName,
        SUM(d.OutstandingBalance) / u.Income AS DebtToIncomeRatio,
        (SELECT SUM(Value) FROM Budgeting.Asset WHERE UserID = d.UserID) / u.Income AS SavingsRate
    FROM 
        Budgeting.Debt d
    JOIN 
        Budgeting.Users u ON d.UserID = u.UserID
    GROUP BY 
        d.UserID,u.FirstName, u.LastName, u.Income) AS Subquery;

----Data inserts


INSERT INTO Budgeting.Payments (PaymentDate, Amount, PaymentMethodID)
VALUES ('2024-04-07', 500.00, 2);
