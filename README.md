# Financial-Budgeting-Application

## Team 11
- Basak Bakirci
- Ketan Keshava
- Nagalekha Ramesh
- Ruchika Shashidhara

## Buisness Problem
Many young adults unfortunately live paycheck to paycheck, they don't have a good view of their finances, they suffer from lifestyle creep where their spending increases with their income and their debts grow with a snowball effect without them realizing. They are often overwhelmed with the process of debt repayment, and they don't know where to start or where to do next without guidance from a financial advisor, which can come at its own additional cost.

## Mission Statement
"Our goal is to empower professionals, between the ages of 25 and 60 by equipping them with the tools and insights to take charge of their finances, enhance their spending habits and build a financial future. With our NewSQL database we strive to offer a platform that not only tracks budgets, categorizes expenses and analyzes spending patterns but also facilitates effective debt repayment, efficient asset management and promotes financial transparency. By fostering a culture of improved saving habits, debt reduction strategies and financial literacy our aim is to guide individuals from living paycheck to paycheck towards a path of well being and long term prosperity."

## Buisness Objectives
- Improved Financial Understanding and Transparency
- Enhance transparency and financial literacy by providing a holistic view of consumer transactions, debts and assets
- Debt and Asset Management
- Empower users to create structured plans for managing debts while enabling efficient management of assets for long term growth.
- User Engagement and Motivation
- Utilize existing user spending data to offer insights into spending trends, suggest avenues for financial advancement inspiring users to reach their objectives.

## Our Solution
- Facilitate Budgeting
  - Facilitate budgeting, expense tracking, debt repayment, financial goal monitoring, and subscription management functionalities within the budgeting application.
- Holistic View of Transactions
  - Provide transparency into transaction and spending habits holistically from different data sources.
- Efficient Debt and Asset Management
  - Facilitate users to manage assets, debts, and subscriptions efficiently.
- Tool for Accountability
  - Provide a tool for accountability in setting and monitoring financial goals while introducing budgeting tools, expense tracking, and subscription management.

## Database Objectives
- To Maintain
  - Sensitive user data, transaction data, financial categorization data, asset and debt data
- To Track The Status Of
  - Debt management, asset management, budgeting habits, spending habits, changes in net worth, overall financial progress
- To Report On
  - Spending habits, debt reduction, asset growth, budget adherence, budget breakdowns by category, overall financial progress, spending trends
- To Perform Search On
  - Transaction data, user profiles, financial history, assets and debts
 
## Entity Relationship Diagram
<img src="DMDD-Final-Project-ERD.png" alt="ERD" width="75%">

### Database Schema

#### Tables
1. **Users**: Stores user information such as username, password (encrypted), name, email, birthdate, profession, income, and social security number (SSN).
2. **Address**: Stores user addresses associated with their profiles.
3. **Asset**: Tracks assets owned by users, including type, value, acquisition date, etc.
4. **Debt**: Tracks debts owed by users, including type, payment details, interest rate, etc.
5. **FinancialInstitutions**: Stores information about financial institutions such as banks.
6. **Accounts**: Stores user account details associated with financial institutions.
7. **Category**: Defines categories for budgeting and expense tracking.
8. **Budget**: Defines user budgets for different categories within specific date ranges.
9. **Inflow**: Tracks incoming funds or income.
10. **Outflow**: Tracks outgoing funds or expenses.
11. **Goals**: Allows users to set financial goals with target amounts and dates.
12. **Bills**: Stores billing information generated from subscriptions or outstanding payments.
13. **SubscriptionPlan**: Defines subscription plans available to users.
14. **SubscriptionPlanUserMap**: Maps users to subscription plans they have availed.
15. **PaymentMethod**: Stores user payment methods such as credit/debit cards.
16. **Payments**: Records payments made by users.

#### Functions
1. **ValidateUserName**: Validates the format of usernames.
2. **ValidatePassword**: Validates the strength of passwords.
3. **ValidateName**: Validates common name fields like first and last names.
4. **ValidateEmail**: Validates the format of email addresses.
5. **ValidateSSN**: Validates the format of social security numbers.
6. **CalculateAge**: Calculates the age based on a given birthdate.
7. **GetTypeID**: Retrieves the type ID for a given asset/debt type.
8. **ValidateStreetNumberOrStreetName**: Validates street number and name formats.
9. **ValidateCityStateCountry**: Validates city, state, and country name formats.
10. **ValidateZipCode**: Validates zip code formats.
11. **ValidateRoutingNumber**: Validates routing number formats.
12. **ValidateAccountNumber**: Validates account number formats.
13. **ValidateSecurityCode**: Validates credit/debit card security code formats.
14. **ValidateCardNumber**: Validates credit/debit card number formats.
15. **ValidatePaymentAmount**: Validates payment amounts against outstanding bills.
16. **ValidateDates**: Validates date ranges.

#### Triggers
1. **UpdateBillingStatus**: Updates billing status to "Paid" after a payment is made.
2. **GenerateBillOnSubscription**: Generates bills when users avail new subscription plans.

### Encryption
- Passwords in the **Users** table are stored in encrypted form using AES symmetric key encryption.

## Views

[DDL View SQL File](SQL_Code/ddl_view.sql)

1. **MonthlyBudgetPerformance**: Summarizes the budget performance for each user by comparing budgeted amounts with actual expenses on a monthly basis.

2. **UserFinancialOverview**: Presents an overview of each user's financial status, including total inflows, outflows, net cash flow, total assets, total liabilities, and net worth.

3. **FinancialHealthScore**: Calculates the financial health score for each user based on their debt-to-income ratio and savings rate.

4. **TransactionHistory**: Combines inflow and outflow transactions for each user, providing a comprehensive transaction history.

5. **Budgeting.BudgetSummary**: Summarizes the budget performance for each user by calculating the remaining amount after deducting outflows from the budgeted amount.

6. **AssetAllocation**: Analyzes the asset allocation of each user by categorizing total asset values and calculating their percentage composition.

7. **DebtOverview**: Provides an overview of each user's debt, including total debt, average monthly payment, and debt-to-income ratio.

8. **FinancialGoalProgress**: Tracks the progress of financial goals for each user, categorizing them as completed, overdue, or in progress.

9. **BudgetCategoryBreakdown**: Breaks down expenses by budget categories for each user, showing the total amount spent in each category.

10. **IncomeExpenseTrendAnalysis**: Analyzes the trend of inflows and outflows for each user over time, categorized by month.


## Reports
[Debt Overview Report](Reports/DebtOverview_Report.csv) : Summarizes debt-related information for each sample user, including their total debt, average monthly payment, and debt-to-income ratio.

[Financial Health Score Report](Reports/FinancialHealthScore_Report.csv) : Calculates the financial health score for each sample user based on their debt-to-income ratio and savings rate, categorizing them as Excellent, Good, Fair, or Poor.

[Transaction History Report for User1 (John Doe)](Reports/TransactionHistory_Report_User1_JohnDoe_Report.csv) : Combines inflow and outflow transactions for User 1: John Doe, providing a comprehensive transaction history sorted by date including transaction type, account number, institution name, amount, and date.


## Visualizations
<img src="Visualizations/Visualization_Distribution_of_Assest_Types.jpeg" alt="Distribution of Asset Types" width="75%">
<img src="Visualizations/Visualization_Income_Distribution_Amoung_Users.jpeg" alt="Income Distribution Among Users" width="75%">
<img src="Visualizations/Visualization_Monthly_Budget_Vs_Actual_By_Category.jpeg" alt="Monthly Budget Vs Actual By Category" width="75%">
<img src="Visualizations/Visualization_Total_Bills_Paid_Over_Time.jpeg" alt="Total Bills Paid Over Time" width="75%">




## Summary
We strive to promote financial literacy and wellbeing amongst young adults, who are currently living paycheck to paycheck. We have architected a relational database to be able to scale and support a large number of users and their financial transactions, built checks and balances to support our business model, and constructed views to report on the raw data that we have collected. We believe that this business model will support our users in their path to financial wellbeing.
