---Views

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

   
---Financial Goals Progress Report -- 
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


