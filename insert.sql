USE Group_11_FinancialManagementAndBudgeting;

-- START Insert Data into Budgeting.Users
DECLARE @Password VARCHAR(100) = 'password@123'; -- Specify the length of the VARCHAR variable

IF dbo.ValidatePassword(@Password) = 1
BEGIN
	OPEN SYMMETRIC KEY Project_SymmetricKey
	DECRYPTION BY CERTIFICATE Project11_Certificate;

	DECLARE @EncryptedPassword VARBINARY(8000);

	SET @EncryptedPassword = ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), @Password)

    -- User 1
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('SarahSmith', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'sarah123!'), 'Sarah', 'Smith', 'sarah.smith@example.com', '1985-05-15', 'Marketing Manager', 65000.00, '111-22-3333');

    -- User 2
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('DavidJohnson', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'david@2023'), 'David', 'Johnson', 'david.johnson@example.com', '1978-09-23', 'Financial Analyst', 75000.00, '444-55-6666');

    -- User 3
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('EmilyBrown', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'emilyBROWN!89'), 'Emily', 'Brown', 'emily.brown@example.com', '1992-12-10', 'Graphic Designer', 55000.00, '777-88-9999');

    -- User 4
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('MichaelJones', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'michael_1234'), 'Michael', 'Jones', 'michael.jones@example.com', '1980-07-03', 'Sales Manager', 70000.00, '222-33-4444');

    -- User 5
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('AmandaWilson', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'amanda!wilson'), 'Amanda', 'Wilson', 'amanda.wilson@example.com', '1987-04-20', 'Nurse', 60000.00, '555-66-7777');

    -- User 6
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('RobertTaylor', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'robert1234!'), 'Robert', 'Taylor', 'robert.taylor@example.com', '1975-11-28', 'Architect', 80000.00, '888-99-0000');

    -- User 7
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('JenniferMiller', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'jenniferM_456'), 'Jennifer', 'Miller', 'jennifer.miller@example.com', '1983-03-17', 'Teacher', 55000.00, '123-45-6789');

    -- User 8
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('ChristopherClark', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'clark_789!'), 'Christopher', 'Clark', 'christopher.clark@example.com', '1995-08-05', 'Software Developer', 65000.00, '987-65-4321');

    -- User 9
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('LauraMartinez', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'lauraMartinez2022'), 'Laura', 'Martinez', 'laura.martinez@example.com', '1989-06-12', 'Human Resources Manager', 70000.00, '456-78-9012');

    -- User 10
    INSERT INTO Budgeting.Users (UserName, Password, FirstName, LastName, Email, Birthdate, Profession, Income, SSN)
    VALUES ('WilliamLee', ENCRYPTBYKEY(KEY_GUID('Project_SymmetricKey'), 'lee!william98'), 'William', 'Lee', 'william.lee@example.com', '1984-09-30', 'Accountant', 60000.00, '135-79-2468');

END
-- END Insert Data into Budgeting.Users

-- Address for User 1
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (1, '123#', 'MainStreet', 'Springfield', 'ILLINOIS', '12345', 'USA');

-- Address for User 2
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (2, '456', 'Broadway', 'New York', 'NEW YORK', '10001', 'USA');

-- Address for User 3
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (3, '789', 'OakAvenue', 'Los Angeles', 'CALIFORNIA', '90001', 'USA');

-- Address for User 4
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (4, '1011', 'PineStreet', 'Seattle', 'WASHINGTON', '98101', 'USA');

-- Address for User 5
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (5, '1213', 'CedarLane', 'Chicago', 'ILLINOIS', '60601', 'USA');

-- Address for User 6
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (6, '1415', 'ElmStreet', 'Dallas', 'TEXAS', '75201', 'USA');

-- Address for User 7
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (7, '1617', 'MapleAvenue', 'Miami', 'FLORIDA', '33101', 'USA');

-- Address for User 8
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (8, '1819', 'SycamoreDrive', 'Atlanta', 'GEORGIA', '30301', 'USA');

-- Address for User 9
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (9, '2021', 'WillowStreet', 'Houston', 'TEXAS', '77001', 'USA');

-- Address for User 10
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (10, '2223', 'HickoryLane', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 1
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'HillsideStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 2
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'CalumetStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 3
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'TremontStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 4
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'HuntingtonStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');


-- Address for Financial Institution 5
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'HillsideStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 6
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'BeaconStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 7
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'WashingtonStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 8
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'ThondikeStreet', 'Boston', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 9
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'HillsideStreet', 'New York', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 10
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '2223', 'HillsideStreet', 'Delaware', 'MASSACHUSETTS', '02101', 'USA');

-- Address for Financial Institution 11
INSERT INTO Budgeting.Address (UserID, StreetNumber, StreetName, City, State, ZipCode, Country)
VALUES (NULL, '007', 'BurgandyRoad', 'Austin', 'TEXAS', '02101', 'USA');

-- Insert Data into Asset

-- Insert into Asset with Cash
DECLARE @CashTypeID INT;
SET @CashTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Cash');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-15', 2, 1500.00, '2024-04-02', @CashTypeID);

-- Insert into Asset with Investments
DECLARE @InvestmentsTypeID INT;
SET @InvestmentsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Investments');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-16', 3, 25000.00, '2024-04-03', @InvestmentsTypeID);

-- Insert into Asset with Real Estate
DECLARE @RealEstateTypeID INT;
SET @RealEstateTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Real Estate');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-17', 4, 350000.00, '2024-04-04', @RealEstateTypeID);

-- Insert into Asset with Vehicles
DECLARE @VehiclesTypeID INT;
SET @VehiclesTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Vehicles');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-18', 5, 20000.00, '2024-04-05', @VehiclesTypeID);

-- Insert into Asset with Retirement Accounts
DECLARE @RetirementAccountsTypeID INT;
SET @RetirementAccountsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Retirement Accounts');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-19', 6, 100000.00, '2024-04-06', @RetirementAccountsTypeID);

-- Insert into Asset with Business Interests
DECLARE @BusinessInterestsTypeID INT;
SET @BusinessInterestsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Business Interests');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-20', 7, 50000.00, '2024-04-07', @BusinessInterestsTypeID);

-- Insert into Asset with Personal Property
DECLARE @PersonalPropertyTypeID INT;
SET @PersonalPropertyTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Personal Property');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-21', 8, 30000.00, '2024-04-08', @PersonalPropertyTypeID);

-- Insert into Asset with Intellectual Property
DECLARE @IntellectualPropertyTypeID INT;
SET @IntellectualPropertyTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Intellectual Property');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-22', 9, 200000.00, '2024-04-09', @IntellectualPropertyTypeID);

-- Insert into Asset with Insurance Policies
DECLARE @InsurancePoliciesTypeID INT;
SET @InsurancePoliciesTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Insurance Policies');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-23', 10, 5000.00, '2024-04-10', @InsurancePoliciesTypeID);

-- Insert into Asset with Other Financial Assets
DECLARE @OtherFinancialAssetsTypeID INT;
SET @OtherFinancialAssetsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Other Financial Assets');
INSERT INTO Budgeting.Asset (EffectiveDate, UserID, Value, AcquisitionDate, TypeID)
VALUES ('2024-05-24', 11, 75000.00, '2024-04-11', @OtherFinancialAssetsTypeID);

-- Insert into Debt with Cash
DECLARE @CashTypeID INT;
SET @CashTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Cash');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-11', 2, @CashTypeID, 200.00, 300.00, 5000.00, 0.03, '2024-05-11');

-- Insert into Debt with Investments
DECLARE @InvestmentsTypeID INT;
SET @InvestmentsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Investments');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-12', 3, @InvestmentsTypeID, 300.00, 400.00, 6000.00, 0.04, '2024-05-12');

-- Insert into Debt with Real Estate
DECLARE @RealEstateTypeID INT;
SET @RealEstateTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Real Estate');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-13', 4, @RealEstateTypeID, 400.00, 500.00, 7000.00, 0.05, '2024-05-13');

-- Insert into Debt with Vehicles
DECLARE @VehiclesTypeID INT;
SET @VehiclesTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Vehicles');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-14', 5, @VehiclesTypeID, 500.00, 600.00, 8000.00, 0.06, '2024-05-14');

-- Insert into Debt with Retirement Accounts
DECLARE @RetirementAccountsTypeID INT;
SET @RetirementAccountsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Retirement Accounts');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-15', 6, @RetirementAccountsTypeID, 600.00, 700.00, 9000.00, 0.07, '2024-05-15');

-- Insert into Debt with Business Interests
DECLARE @BusinessInterestsTypeID INT;
SET @BusinessInterestsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Business Interests');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-16', 7, @BusinessInterestsTypeID, 700.00, 800.00, 10000.00, 0.08, '2024-05-16');

-- Insert into Debt with Personal Property
DECLARE @PersonalPropertyTypeID INT;
SET @PersonalPropertyTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Personal Property');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-17', 8, @PersonalPropertyTypeID, 800.00, 900.00, 11000.00, 0.09, '2024-05-17');

-- Insert into Debt with Intellectual Property
DECLARE @IntellectualPropertyTypeID INT;
SET @IntellectualPropertyTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Intellectual Property');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-18', 9, @IntellectualPropertyTypeID, 900.00, 1000.00, 12000.00, 0.1, '2024-05-18');

-- Insert into Debt with Insurance Policies
DECLARE @InsurancePoliciesTypeID INT;
SET @InsurancePoliciesTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Insurance Policies');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-19', 10, @InsurancePoliciesTypeID, 1000.00, 1100.00, 13000.00, 0.11, '2024-05-19');

-- Insert into Debt with Other Financial Assets
DECLARE @OtherFinancialAssetsTypeID INT;
SET @OtherFinancialAssetsTypeID = (SELECT TypeID FROM Budgeting.Types WHERE TypeName = 'Other Financial Assets');
INSERT INTO Budgeting.Debt (EffectiveDate, UserID, TypeID, Payment, Principle, OutstandingBalance, InterestRate, DueDate)
VALUES ('2024-04-20', 11, @OtherFinancialAssetsTypeID, 1100.00, 1200.00, 14000.00, 0.12, '2024-05-20');

-- Insert for User 2
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (2, 5, 600.00, '2024-03-01', '2024-04-30');

-- Insert for User 3
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (3, 6, 700.00, '2024-03-01', '2024-04-30');

-- Insert for User 4
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (4, 7, 800.00, '2024-03-01', '2024-04-30');

-- Insert for User 5
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (5, 8, 900.00, '2024-03-01', '2024-04-30');

-- Insert for User 6
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (6, 9, 1000.00, '2024-03-01', '2024-04-30');

-- Insert for User 7
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (7, 10, 1100.00, '2024-03-01', '2024-04-30');

-- Insert for User 8
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (8, 11, 1200.00, '2024-03-01', '2024-04-30');

-- Insert for User 9
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (9, 12, 1300.00, '2024-03-01', '2024-04-30');

-- Insert for User 10
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (10, 13, 1400.00, '2024-03-01', '2024-04-30');

-- Insert for User 11
INSERT INTO Budgeting.Budget (UserID, CategoryID, Amount, StartDate, EndDate)
VALUES (11, 14, 1500.00, '2024-03-01', '2024-04-30');

-- Insert for User 2
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (2, 'Buy a new laptop', 1500.00, '2024-10-31', 'IN_PROGRESS');

-- Insert for User 3
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (3, 'Pay off credit card debt', 5000.00, '2024-11-30', 'IN_PROGRESS');

-- Insert for User 4
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (4, 'Save for down payment', 20000.00, '2025-06-30', 'IN_PROGRESS');

-- Insert for User 5
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (5, 'Renovate kitchen', 10000.00, '2025-03-31', 'IN_PROGRESS');

-- Insert for User 6
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (6, 'Start emergency fund', 5000.00, '2024-09-30', 'IN_PROGRESS');

-- Insert for User 7
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (7, 'Invest in stocks', 3000.00, '2024-12-31', 'IN_PROGRESS');

-- Insert for User 8
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (8, 'Save for childs education', 25000.00, '2026-01-31', 'IN_PROGRESS');

-- Insert for User 9
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (9, 'Purchase a new car', 15000.00, '2025-08-31', 'IN_PROGRESS');

-- Insert for User 10
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (10, 'Plan for retirement', 100000.00, '2030-12-31', 'IN_PROGRESS');

-- Insert for User 11
INSERT INTO Budgeting.Goals (UserID, Description, TargetAmount, TargetDate, Status)
VALUES (11, 'Save for dream vacation', 5000.00, '2025-05-31', 'IN_PROGRESS');


-- Inserting Data into Financial Institutions
INSERT INTO Budgeting.FinancialInstitutions (Name, RoutingNumber, AddressID)
VALUES 
('Ally Bank', '5432-1098-7', 24),
('Chase Bank', '9876-5432-1', 25),
('Bank of America', '4567-8901-2', 26),
('Wells Fargo', '7890-1234-5', 27),
('TD Bank', '2345-6789-0', 28),
('Citibank', '5678-9012-3', 29),
('HSBC Bank', '8901-2345-6', 30),
('PNC Bank', '3456-7890-1', 31),
('Capital One', '6789-0123-4', 32),
('US Bank', '0123-4567-8', 33);

INSERT INTO Budgeting.FinancialInstitutions (Name, RoutingNumber, AddressID)
VALUES 
('Ally Bank', '5432-1098-7', 24),
('Chase Bank', '9876-5432-1', 25),
('Bank of America', '4567-8901-2', 26),
('Wells Fargo', '7890-1234-5', 27),
('TD Bank', '2345-6789-0', 28),
('Citibank', '5678-9012-3', 29),
('HSBC Bank', '8901-2345-6', 30),
('PNC Bank', '3456-7890-1', 31),
('Capital One', '6789-0123-4', 32),
('US Bank', '0123-4567-8', 33);

INSERT INTO Group_11_FinancialManagementAndBudgeting.Budgeting.Accounts
(AccountNumber, InstitutionID, UserID, AccountName)
VALUES
-- John Doe's accounts
('12345678', 5, 1, 'John Does Checking Account'),
('12345679', 5, 1, 'John Does Savings Account'),
('5432109876', 16, 1, 'John Does Visa Credit Card'),
('9876543210', 16, 1, 'John Does Mastercard Credit Card'),

-- Sarah Smith's accounts
('98765432', 17, 3, 'Sarah Smiths Savings Account'),
('98765433', 17, 3, 'Sarah Smiths Checking Account'),
('1234567890', 18, 3, 'Sarah Smiths American Express Credit Card'),
('9876543210', 18, 3, 'Sarah Smiths Discover Credit Card'),

-- David Johnson's accounts
('45678901', 19, 4, 'David Johnsons Checking Account'),
('45678902', 19, 4, 'David Johnsons Savings Account'),
('456789012345', 20, 4, 'David Johnsons Visa Credit Card'),
('9876543210', 20, 4, 'David Johnsons Mastercard Credit Card'),

-- Emily Brown's accounts
('23456789', 21, 5, 'Emily Browns Savings Account'),
('23456790', 21, 5, 'Emily Browns Checking Account'),
('234567890123', 22, 5, 'Emily Browns Discover Credit Card'),
('876543210', 22, 5, 'Emily Browns Visa Credit Card'),

-- Michael Jones's accounts
('89012345', 23, 6, 'Michael Jones Checking Account'),
('89012346', 23, 6, 'Michael Jones Savings Account'),
('890123456789', 24, 6, 'Michael Jones Mastercard Credit Card'),
('3456789012', 24, 6, 'Michael Jones American Express Credit Card'),

-- Amanda Wilson's accounts
('34567890', 25, 7, 'Amanda Wilsons Savings Account'),
('34567891', 25, 7, 'Amanda Wilsons Checking Account'),
('6789012345', 19, 7, 'Amanda Wilsons Visa Credit Card'),
('9012345678', 20, 7, 'Amanda Wilsons Discover Credit Card'),

-- Robert Taylor's accounts
('67890123', 17, 8, 'Robert Taylors Checking Account'),
('67890124', 17, 8, 'Robert Taylors Savings Account'),
('0123456789', 19, 8, 'Robert Taylors Mastercard Credit Card'),
('7890123456', 18, 8, 'Robert Taylors American Express Credit Card'),

-- Jennifer Miller's accounts
('90123456', 16, 9, 'Jennifer Millers Savings Account'),
('90123457', 19, 9, 'Jennifer Millers Checking Account'),
('3456789012', 21, 9, 'Jennifer Millers Discover Credit Card'),
('4567890123', 20, 9, 'Jennifer Millers Visa Credit Card'),

-- Christopher Clark's accounts
('01234567', 21, 10, 'Christopher Clarks Checking Account'),
('01234568', 21, 10, 'Christopher Clarks Savings Account'),
('9012345678', 22, 10, 'Christopher Clarks American Express Credit Card'),
('2345678901', 22, 10, 'Christopher Clarks Mastercard Credit Card'),

-- Laura Martinez's accounts
('12345678', 23, 11, 'Laura Martinezs Savings Account'),
('12345679', 23, 11, 'Laura Martinezs Checking Account'),
('7890123456', 24, 11, 'Laura Martinezs Visa Credit Card'),
('5678901234', 24, 11, 'Laura Martinezs Discover Credit Card'),

-- William Lee's accounts
('23456789', 25, 12, 'William Lees Checking Account'),
('23456790', 25, 12, 'William Lees Savings Account'),
('2345678901', 16, 12, 'William Lees Mastercard Credit Card'),
('9012345678', 16, 12, 'William Lees American Express Credit Card');

INSERT INTO Group_11_FinancialManagementAndBudgeting.Budgeting.Outflow
(AccountNumber, Description, InstitutionID, Amount, [Date], CategoryID)
VALUES
-- John Doe's Visa Credit Card
('5432109876', 'Groceries', 16, 50.00, '2024-04-10', 3),
('5432109876', 'Dining Out', 16, 30.00, '2024-04-10', 4),
('5432109876', 'Entertainment', 16, 20.00, '2024-04-10', 5),
('5432109876', 'Transportation', 16, 25.00, '2024-04-11', 6),
('5432109876', 'Shopping', 16, 40.00, '2024-04-11', 7),
('5432109876', 'Utilities', 16, 35.00, '2024-04-12', 8),

-- John Doe's Mastercard Credit Card
('9876543210', 'Groceries', 16, 45.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 16, 35.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 16, 25.00, '2024-04-11', 5),
('9876543210', 'Transportation', 16, 20.00, '2024-04-11', 6),
('9876543210', 'Shopping', 16, 30.00, '2024-04-12', 7),
('9876543210', 'Utilities', 16, 40.00, '2024-04-12', 8),

-- Sarah Smith's American Express Credit Card
('1234567890', 'Groceries', 18, 55.00, '2024-04-10', 3),
('1234567890', 'Dining Out', 18, 25.00, '2024-04-10', 4),
('1234567890', 'Entertainment', 18, 30.00, '2024-04-11', 5),
('1234567890', 'Transportation', 18, 20.00, '2024-04-11', 6),
('1234567890', 'Shopping', 18, 35.00, '2024-04-12', 7),
('1234567890', 'Utilities', 18, 45.00, '2024-04-12', 8),

-- Sarah Smith's Discover Credit Card
('9876543210', 'Groceries', 18, 60.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 18, 30.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 18, 25.00, '2024-04-11', 5),
('9876543210', 'Transportation', 18, 15.00, '2024-04-11', 6),
('9876543210', 'Shopping', 18, 40.00, '2024-04-12', 7),
('9876543210', 'Utilities', 18, 50.00, '2024-04-12', 8),

-- David Johnson's Visa Credit Card
('456789012345', 'Groceries', 20, 40.00, '2024-04-10', 3),
('456789012345', 'Dining Out', 20, 30.00, '2024-04-10', 4),
('456789012345', 'Entertainment', 20, 20.00, '2024-04-11', 5),
('456789012345', 'Transportation', 20, 25.00, '2024-04-11', 6),
('456789012345', 'Shopping', 20, 35.00, '2024-04-12', 7),
('456789012345', 'Utilities', 20, 45.00, '2024-04-12', 8),

-- David Johnson's Mastercard Credit Card
('9876543210', 'Groceries', 20, 50.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 20, 40.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 20, 30.00, '2024-04-11', 5),
('9876543210', 'Transportation', 20, 20.00, '2024-04-11', 6),
('9876543210', 'Shopping', 20, 30.00, '2024-04-12', 7),
('9876543210', 'Utilities', 20, 40.00, '2024-04-12', 8),

-- Emily Brown's Discover Credit Card
('234567890123', 'Groceries', 22, 45.00, '2024-04-10', 3),
('234567890123', 'Dining Out', 22, 35.00, '2024-04-10', 4),
('234567890123', 'Entertainment', 22, 25.00, '2024-04-11', 5),
('234567890123', 'Transportation', 22, 15.00, '2024-04-11', 6),
('234567890123', 'Shopping', 22, 40.00, '2024-04-12', 7),
('234567890123', 'Utilities', 22, 50.00, '2024-04-12', 8),

-- Emily Brown's Visa Credit Card
('876543210', 'Groceries', 22, 50.00, '2024-04-10', 3),
('876543210', 'Dining Out', 22, 30.00, '2024-04-10', 4),
('876543210', 'Entertainment', 22, 20.00, '2024-04-11', 5),
('876543210', 'Transportation', 22, 25.00, '2024-04-11', 6),
('876543210', 'Shopping', 22, 35.00, '2024-04-12', 7),
('876543210', 'Utilities', 22, 45.00, '2024-04-12', 8),

-- Michael Jones's American Express Credit Card
('3456789012', 'Groceries', 24, 60.00, '2024-04-10', 3),
('3456789012', 'Dining Out', 24, 30.00, '2024-04-10', 4),
('3456789012', 'Entertainment', 24, 25.00, '2024-04-11', 5),
('3456789012', 'Transportation', 24, 15.00, '2024-04-11', 6),
('3456789012', 'Shopping', 24, 40.00, '2024-04-12', 7),
('3456789012', 'Utilities', 24, 50.00, '2024-04-12', 8),

-- Michael Jones's Mastercard Credit Card
('890123456789', 'Groceries', 24, 40.00, '2024-04-10', 3),
('890123456789', 'Dining Out', 24, 30.00, '2024-04-10', 4),
('890123456789', 'Entertainment', 24, 20.00, '2024-04-11', 5),
('890123456789', 'Transportation', 24, 25.00, '2024-04-11', 6),
('890123456789', 'Shopping', 24, 35.00, '2024-04-12', 7),
('890123456789', 'Utilities', 24, 45.00, '2024-04-12', 8),

-- Amanda Wilson's Discover Credit Card
('9012345678', 'Groceries', 22, 45.00, '2024-04-10', 3),
('9012345678', 'Dining Out', 22, 35.00, '2024-04-10', 4),
('9012345678', 'Entertainment', 22, 25.00, '2024-04-11', 5),
('9012345678', 'Transportation', 22, 15.00, '2024-04-11', 6),
('9012345678', 'Shopping', 22, 40.00, '2024-04-12', 7),
('9012345678', 'Utilities', 22, 50.00, '2024-04-12', 8);

INSERT INTO Group_11_FinancialManagementAndBudgeting.Budgeting.Outflow
(AccountNumber, Description, InstitutionID, Amount, [Date], CategoryID)
VALUES
-- John Doe's Visa Credit Card
('5432109876', 'Groceries', 16, 50.00, '2024-04-10', 3),
('5432109876', 'Dining Out', 16, 30.00, '2024-04-10', 4),
('5432109876', 'Entertainment', 16, 20.00, '2024-04-10', 5),
('5432109876', 'Transportation', 16, 25.00, '2024-04-11', 6),
('5432109876', 'Shopping', 16, 40.00, '2024-04-11', 7),
('5432109876', 'Utilities', 16, 35.00, '2024-04-12', 8),

-- John Doe's Mastercard Credit Card
('9876543210', 'Groceries', 16, 45.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 16, 35.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 16, 25.00, '2024-04-11', 5),
('9876543210', 'Transportation', 16, 20.00, '2024-04-11', 6),
('9876543210', 'Shopping', 16, 30.00, '2024-04-12', 7),
('9876543210', 'Utilities', 16, 40.00, '2024-04-12', 8),

-- Sarah Smith's American Express Credit Card
('1234567890', 'Groceries', 18, 55.00, '2024-04-10', 3),
('1234567890', 'Dining Out', 18, 25.00, '2024-04-10', 4),
('1234567890', 'Entertainment', 18, 30.00, '2024-04-11', 5),
('1234567890', 'Transportation', 18, 20.00, '2024-04-11', 6),
('1234567890', 'Shopping', 18, 35.00, '2024-04-12', 7),
('1234567890', 'Utilities', 18, 45.00, '2024-04-12', 8),

-- Sarah Smith's Discover Credit Card
('9876543210', 'Groceries', 18, 60.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 18, 30.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 18, 25.00, '2024-04-11', 5),
('9876543210', 'Transportation', 18, 15.00, '2024-04-11', 6),
('9876543210', 'Shopping', 18, 40.00, '2024-04-12', 7),
('9876543210', 'Utilities', 18, 50.00, '2024-04-12', 8),

-- David Johnson's Visa Credit Card
('456789012345', 'Groceries', 20, 40.00, '2024-04-10', 3),
('456789012345', 'Dining Out', 20, 30.00, '2024-04-10', 4),
('456789012345', 'Entertainment', 20, 20.00, '2024-04-11', 5),
('456789012345', 'Transportation', 20, 25.00, '2024-04-11', 6),
('456789012345', 'Shopping', 20, 35.00, '2024-04-12', 7),
('456789012345', 'Utilities', 20, 45.00, '2024-04-12', 8),

-- David Johnson's Mastercard Credit Card
('9876543210', 'Groceries', 20, 50.00, '2024-04-10', 3),
('9876543210', 'Dining Out', 20, 40.00, '2024-04-10', 4),
('9876543210', 'Entertainment', 20, 30.00, '2024-04-11', 5),
('9876543210', 'Transportation', 20, 20.00, '2024-04-11', 6),
('9876543210', 'Shopping', 20, 30.00, '2024-04-12', 7),
('9876543210', 'Utilities', 20, 40.00, '2024-04-12', 8),

-- Emily Brown's Discover Credit Card
('234567890123', 'Groceries', 22, 45.00, '2024-04-10', 3),
('234567890123', 'Dining Out', 22, 35.00, '2024-04-10', 4),
('234567890123', 'Entertainment', 22, 25.00, '2024-04-11', 5),
('234567890123', 'Transportation', 22, 15.00, '2024-04-11', 6),
('234567890123', 'Shopping', 22, 40.00, '2024-04-12', 7),
('234567890123', 'Utilities', 22, 50.00, '2024-04-12', 8),

-- Emily Brown's Visa Credit Card
('876543210', 'Groceries', 22, 50.00, '2024-04-10', 3),
('876543210', 'Dining Out', 22, 30.00, '2024-04-10', 4),
('876543210', 'Entertainment', 22, 20.00, '2024-04-11', 5),
('876543210', 'Transportation', 22, 25.00, '2024-04-11', 6),
('876543210', 'Shopping', 22, 35.00, '2024-04-12', 7),
('876543210', 'Utilities', 22, 45.00, '2024-04-12', 8),

-- Michael Jones's American Express Credit Card
('3456789012', 'Groceries', 24, 60.00, '2024-04-10', 3),
('3456789012', 'Dining Out', 24, 30.00, '2024-04-10', 4),
('3456789012', 'Entertainment', 24, 25.00, '2024-04-11', 5),
('3456789012', 'Transportation', 24, 15.00, '2024-04-11', 6),
('3456789012', 'Shopping', 24, 40.00, '2024-04-12', 7),
('3456789012', 'Utilities', 24, 50.00, '2024-04-12', 8),

-- Michael Jones's Mastercard Credit Card
('890123456789', 'Groceries', 24, 40.00, '2024-04-10', 3),
('890123456789', 'Dining Out', 24, 30.00, '2024-04-10', 4),
('890123456789', 'Entertainment', 24, 20.00, '2024-04-11', 5),
('890123456789', 'Transportation', 24, 25.00, '2024-04-11', 6),
('890123456789', 'Shopping', 24, 35.00, '2024-04-12', 7),
('890123456789', 'Utilities', 24, 45.00, '2024-04-12', 8),

-- Amanda Wilson's Discover Credit Card
('9012345678', 'Groceries', 22, 45.00, '2024-04-10', 3),
('9012345678', 'Dining Out', 22, 35.00, '2024-04-10', 4),
('9012345678', 'Entertainment', 22, 25.00, '2024-04-11', 5),
('9012345678', 'Transportation', 22, 15.00, '2024-04-11', 6),
('9012345678', 'Shopping', 22, 40.00, '2024-04-12', 7),
('9012345678', 'Utilities', 22, 50.00, '2024-04-12', 8);





