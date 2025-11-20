IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bc_finance')
BEGIN
    EXEC('CREATE SCHEMA [bc_finance]')
END;

GO

CREATE OR ALTER VIEW [bc_finance].[GLEntriesBalanceSheet]
AS
SELECT
    GLAccount.[BC Company]            as [BC Company] ,
    GLAccount.[Income/Balance]        AS incomeBalance,
    GLAccount.[No.]                   AS glAccountNo,
    GLEntry.[Posting Date]            AS postingDate,
    GLEntry.[Amount]                  AS amount,
    GLEntry.[Dimension Set ID]        AS dimensionSetID,
    GLEntry.[Source Code]             AS sourceCode,
    GLEntry.[Entry No.]               AS entryNo,
    GLEntry.[SystemModifiedAt]        AS systemModifiedAt,
    GLEntry.[Description]             AS description,
    GLEntry.[Source Type]             AS sourceType,
    GLEntry.[Source No.]              AS sourceNo
FROM [bc].[GL Account] AS GLAccount
INNER JOIN [bc].[GL Entry] AS GLEntry
    ON GLEntry.[G/L Account No.] = GLAccount.[No.]
   AND GLEntry.[BC Company] = GLAccount.[BC Company]
WHERE GLAccount.[Income/Balance] = 'Balance Sheet';

GO;

CREATE OR ALTER VIEW [bc_finance].[GLEntriesIncomeStatement]
AS
SELECT
    GLAccount.[BC Company]            as [BC Company] ,
    GLAccount.[Income/Balance]        AS incomeBalance,
    GLAccount.[No.]                   AS accountNo,
    GLEntry.[Posting Date]            AS postingDate,
    GLEntry.[Amount]                  AS amount,
    GLEntry.[Dimension Set ID]        AS dimensionSetID,
    GLEntry.[Source Code]             AS sourceCode,
    GLEntry.[Entry No.]               AS entryNo,
    GLEntry.[SystemModifiedAt]        AS systemModifiedAt,
    GLEntry.[Description]             AS description,
    GLEntry.[Source Type]             AS sourceType,
    GLEntry.[Source No.]              AS sourceNo
FROM [bc].[GL Account] AS GLAccount
INNER JOIN [bc].[GL Entry] AS GLEntry
    ON GLEntry.[G/L Account No.] = GLAccount.[No.]
   AND GLEntry.[BC Company] = GLAccount.[BC Company]
WHERE GLAccount.[Income/Balance] = 'Income Statement';

GO;

CREATE OR ALTER VIEW [bc_finance].[GLEntriesClosing]
AS
SELECT
    GLAccount.[BC Company]            as [BC Company] ,
    GLAccount.[Income/Balance]        AS incomeBalance,
    GLAccount.[No.]                   AS glAccountNo,
    GLEntry.[Posting Date]            AS postingDate,
    GLEntry.[Amount]                  AS amount,
    GLEntry.[Dimension Set ID]        AS dimensionSetID,
    GLEntry.[Source Code]             AS sourceCode,
    GLEntry.[Entry No.]               AS entryNo,
    GLEntry.[SystemModifiedAt]        AS systemModifiedAt,
    GLEntry.[Description]             AS description,
    GLEntry.[Source Type]             AS sourceType,
    GLEntry.[Source No.]              AS sourceNo
FROM [bc].[GL Account] AS GLAccount
INNER JOIN [bc].[GL Entry] AS GLEntry
    ON GLEntry.[G/L Account No.] = GLAccount.[No.]
   AND GLEntry.[BC Company] = GLAccount.[BC Company];

GO;

CREATE OR ALTER VIEW [bc_finance].[Dimensions]
AS

SELECT
    GLS.[BC Company]                   as [BC Company] ,
    GLS.[Global Dimension 1 Code]     AS dim1Code,
    Dim1.[Name]                       AS dim1Name,
    Dim1.[Code Caption]               AS dim1Caption,
    GLS.[Global Dimension 2 Code]     AS dim2Code,
    Dim2.[Name]                       AS dim2Name,
    Dim2.[Code Caption]               AS dim2Caption,
    GLS.[Shortcut Dimension 3 Code]   AS dim3Code,
    Dim3.[Name]                       AS dim3Name,
    Dim3.[Code Caption]               AS dim3Caption,
    GLS.[Shortcut Dimension 4 Code]   AS dim4Code,
    Dim4.[Name]                       AS dim4Name,
    Dim4.[Code Caption]               AS dim4Caption,
    GLS.[Shortcut Dimension 5 Code]   AS dim5Code,
    Dim5.[Name]                       AS dim5Name,
    Dim5.[Code Caption]               AS dim5Caption,
    GLS.[Shortcut Dimension 6 Code]   AS dim6Code,
    Dim6.[Name]                       AS dim6Name,
    Dim6.[Code Caption]               AS dim6Caption,
    GLS.[Shortcut Dimension 7 Code]   AS dim7Code,
    Dim7.[Name]                       AS dim7Name,
    Dim7.[Code Caption]               AS dim7Caption,
    GLS.[Shortcut Dimension 8 Code]   AS dim8Code,
    Dim8.[Name]                       AS dim8Name,
    Dim8.[Code Caption]               AS dim8Caption
FROM [bc].[General Ledger Setup] AS GLS
Left JOIN [bc].[Dimension] AS Dim1
    ON Dim1.[Code] = GLS.[Global Dimension 1 Code]
   AND Dim1.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim2
    ON Dim2.[Code] = GLS.[Global Dimension 2 Code]
   AND Dim2.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim3
    ON Dim3.[Code] = GLS.[Shortcut Dimension 3 Code]
   AND Dim3.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim4
    ON Dim4.[Code] = GLS.[Shortcut Dimension 4 Code]
   AND Dim4.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim5
    ON Dim5.[Code] = GLS.[Shortcut Dimension 5 Code]
   AND Dim5.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim6
    ON Dim6.[Code] = GLS.[Shortcut Dimension 6 Code]
   AND Dim6.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim7
    ON Dim7.[Code] = GLS.[Shortcut Dimension 7 Code]
   AND Dim7.[BC Company] = GLS.[BC Company]
Left JOIN [bc].[Dimension] AS Dim8
    ON Dim8.[Code] = GLS.[Shortcut Dimension 8 Code]
   AND Dim8.[BC Company] = GLS.[BC Company];



GO;

CREATE OR ALTER VIEW [bc_finance].[PowerBIDimensionSetEntries]
AS
WITH Setup AS (
    SELECT
        [BC Company] as [BC Company] ,
        [Global Dimension 1 Code]   AS Dim1Code,
        [Global Dimension 2 Code]   AS Dim2Code,
        [Shortcut Dimension 3 Code] AS Dim3Code,
        [Shortcut Dimension 4 Code] AS Dim4Code,
        [Shortcut Dimension 5 Code] AS Dim5Code,
        [Shortcut Dimension 6 Code] AS Dim6Code,
        [Shortcut Dimension 7 Code] AS Dim7Code,
        [Shortcut Dimension 8 Code] AS Dim8Code
    FROM [bc].[General Ledger Setup]
),
DimensionEntries AS (
    SELECT
        DSE.[Dimension Set ID],
        DSE.[Dimension Code],
        DSE.[Dimension Value Code],
        DV.[Name] AS [Dimension Value Name],
        DSE.[BC Company] as [BC Company] 
    FROM [bc].[Dimension Set Entry] AS DSE
    LEFT JOIN [bc].[Dimension Value] AS DV
        ON DV.[Dimension Code] = DSE.[Dimension Code]
       AND DV.[Code] = DSE.[Dimension Value Code]
       AND DV.[BC Company] = DSE.[BC Company]
),
Counts AS (
    SELECT
        [Dimension Set ID],
        [BC Company] ,
        COUNT(*) AS valueCount
    FROM DimensionEntries
    GROUP BY [Dimension Set ID], [BC Company] 
),
Pivoted AS (
    SELECT
        DE.[Dimension Set ID],
        DE.[BC Company] ,
        MAX(CASE WHEN Setup.Dim1Code IS NOT NULL AND Setup.Dim1Code <> '' AND DE.[Dimension Code] = Setup.Dim1Code THEN DE.[Dimension Value Code] END) AS dimension1ValueCode,
        MAX(CASE WHEN Setup.Dim1Code IS NOT NULL AND Setup.Dim1Code <> '' AND DE.[Dimension Code] = Setup.Dim1Code THEN DE.[Dimension Value Name] END) AS dimension1ValueName,
        MAX(CASE WHEN Setup.Dim2Code IS NOT NULL AND Setup.Dim2Code <> '' AND DE.[Dimension Code] = Setup.Dim2Code THEN DE.[Dimension Value Code] END) AS dimension2ValueCode,
        MAX(CASE WHEN Setup.Dim2Code IS NOT NULL AND Setup.Dim2Code <> '' AND DE.[Dimension Code] = Setup.Dim2Code THEN DE.[Dimension Value Name] END) AS dimension2ValueName,
        MAX(CASE WHEN Setup.Dim3Code IS NOT NULL AND Setup.Dim3Code <> '' AND DE.[Dimension Code] = Setup.Dim3Code THEN DE.[Dimension Value Code] END) AS dimension3ValueCode,
        MAX(CASE WHEN Setup.Dim3Code IS NOT NULL AND Setup.Dim3Code <> '' AND DE.[Dimension Code] = Setup.Dim3Code THEN DE.[Dimension Value Name] END) AS dimension3ValueName,
        MAX(CASE WHEN Setup.Dim4Code IS NOT NULL AND Setup.Dim4Code <> '' AND DE.[Dimension Code] = Setup.Dim4Code THEN DE.[Dimension Value Code] END) AS dimension4ValueCode,
        MAX(CASE WHEN Setup.Dim4Code IS NOT NULL AND Setup.Dim4Code <> '' AND DE.[Dimension Code] = Setup.Dim4Code THEN DE.[Dimension Value Name] END) AS dimension4ValueName,
        MAX(CASE WHEN Setup.Dim5Code IS NOT NULL AND Setup.Dim5Code <> '' AND DE.[Dimension Code] = Setup.Dim5Code THEN DE.[Dimension Value Code] END) AS dimension5ValueCode,
        MAX(CASE WHEN Setup.Dim5Code IS NOT NULL AND Setup.Dim5Code <> '' AND DE.[Dimension Code] = Setup.Dim5Code THEN DE.[Dimension Value Name] END) AS dimension5ValueName,
        MAX(CASE WHEN Setup.Dim6Code IS NOT NULL AND Setup.Dim6Code <> '' AND DE.[Dimension Code] = Setup.Dim6Code THEN DE.[Dimension Value Code] END) AS dimension6ValueCode,
        MAX(CASE WHEN Setup.Dim6Code IS NOT NULL AND Setup.Dim6Code <> '' AND DE.[Dimension Code] = Setup.Dim6Code THEN DE.[Dimension Value Name] END) AS dimension6ValueName,
        MAX(CASE WHEN Setup.Dim7Code IS NOT NULL AND Setup.Dim7Code <> '' AND DE.[Dimension Code] = Setup.Dim7Code THEN DE.[Dimension Value Code] END) AS dimension7ValueCode,
        MAX(CASE WHEN Setup.Dim7Code IS NOT NULL AND Setup.Dim7Code <> '' AND DE.[Dimension Code] = Setup.Dim7Code THEN DE.[Dimension Value Name] END) AS dimension7ValueName,
        MAX(CASE WHEN Setup.Dim8Code IS NOT NULL AND Setup.Dim8Code <> '' AND DE.[Dimension Code] = Setup.Dim8Code THEN DE.[Dimension Value Code] END) AS dimension8ValueCode,
        MAX(CASE WHEN Setup.Dim8Code IS NOT NULL AND Setup.Dim8Code <> '' AND DE.[Dimension Code] = Setup.Dim8Code THEN DE.[Dimension Value Name] END) AS dimension8ValueName
    FROM DimensionEntries AS DE
    LEFT JOIN Setup
        ON Setup.[BC Company]  = DE.[BC Company] 
    GROUP BY DE.[Dimension Set ID], DE.[BC Company] 
)
SELECT
    TRY_CONVERT(uniqueidentifier, HASHBYTES('MD5', CONCAT('PowerBI-DimSet-', P.[BC Company] , '-', CAST(P.[Dimension Set ID] AS NVARCHAR(36))))) AS id,
    P.[Dimension Set ID] AS dimensionSetID,
    P.[BC Company] ,
    C.valueCount,
    P.dimension1ValueCode,
    P.dimension1ValueName,
    P.dimension2ValueCode,
    P.dimension2ValueName,
    P.dimension3ValueCode,
    P.dimension3ValueName,
    P.dimension4ValueCode,
    P.dimension4ValueName,
    P.dimension5ValueCode,
    P.dimension5ValueName,
    P.dimension6ValueCode,
    P.dimension6ValueName,
    P.dimension7ValueCode,
    P.dimension7ValueName,
    P.dimension8ValueCode,
    P.dimension8ValueName
FROM Pivoted AS P
INNER JOIN Counts AS C
    ON C.[Dimension Set ID] = P.[Dimension Set ID]
   AND C.[BC Company]  = P.[BC Company] ;

GO;

CREATE OR ALTER VIEW [bc_finance].[GLAccounts]
AS
SELECT
    [BC Company]                     as [BC Company] ,
    [No.]                             AS accountNo,
    [Name]                            AS accountName,
    [Account Type]                    AS accountType,
    [Income/Balance]                  AS incomeBalance,
    [Account Subcategory Entry No.]   AS accountSubcategoryEntryNo,
    [Indentation]                     AS indentation,
    [Totaling]                        AS totaling
FROM [bc].[GL Account];

GO;

CREATE OR ALTER VIEW [bc_finance].[GLAccountCategories]
AS
SELECT
    GAC.[BC Company]                     as [BC Company] ,
    GAC.[Entry No.]                       AS entryNo,
    GAC.[Parent Entry No.]                AS parentEntryNo,
    GAC.[Description]                     AS description,
    GAC.[Presentation Order]              AS presentationOrder,
    GAC.[Sibling Sequence No.]            AS siblingSequenceNo,
    GAC.[Indentation]                     AS indentation,
    GAC.[Account Category]                AS accountCategory,
    GAC.[Income/Balance]                  AS incomeBalance,
    GAC.[Additional Report Definition]    AS additionalReportDefinition,
    GAC.[System Generated]                AS systemGenerated,
    CAST(CASE
             WHEN EXISTS (
                 SELECT 1
                 FROM [bc].[GL Account Category] AS Child
                 WHERE Child.[Parent Entry No.] = GAC.[Entry No.]
                   AND Child.[BC Company] = GAC.[BC Company]
             ) THEN 1
             ELSE 0
         END AS bit)                      AS hasChildren
FROM [bc].[GL Account Category] AS GAC;

GO;

CREATE OR ALTER VIEW [bc_finance].[GLBudgets]
AS
SELECT
    [BC Company]   as [BC Company] ,
    [Name]        AS budgetName,
    [Description] AS budgetDescription
FROM [bc].[GL Budget Name];

GO;

CREATE OR ALTER VIEW [bc_finance].[DateSetup]
AS
WITH SetupData AS (
    SELECT
        Setup.*,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM [bc].[PowerBI Reports Setup] AS Setup
)
SELECT
    TRY_CONVERT(uniqueidentifier, HASHBYTES('MD5', CONCAT('DateSetup-', CAST(SetupData.rn AS NVARCHAR(10))))) AS id,
    SetupData.[BC Company]                               as [BC Company] ,
    SetupData.[First Month of Fiscal Calendar]         AS fiscalCalendarFirstMonth,
    SetupData.[First Day Of Week]                      AS firstDayOfWeek,
    SetupData.[ISO Country Holidays]                   AS isoCountryHolidays,
    SetupData.[Weekly Type]                            AS weeklyType,
    SetupData.[Quarter Week Type]                      AS quarterWeekType,
    SetupData.[Calendar Range]                         AS calendarRange,
    SetupData.[Calendar Gregorian Prefix]              AS calendarPrefix,
    SetupData.[Fiscal Gregorian Prefix]                AS fiscalGregorianPrefix,
    SetupData.[Fiscal Weekly Prefix]                   AS fiscalWeeklyPrefix,
    SetupData.[Use Custom Fiscal Periods]              AS useCustomFisclPeriods,
    SetupData.[Ignore Weekly Fiscal Periods]           AS ignoreWeeklyPeriods,
    COALESCE(NULLIF(SetupData.[Time Zone], ''), 'UTC') AS timeZone,
    CASE
        WHEN SetupData.[Time Zone] IS NULL OR SetupData.[Time Zone] = '' THEN 'Coordinated Universal Time'
        ELSE SetupData.[Time Zone]
    END                                                AS timeZoneDisplayName,
    SetupData.[Date Table Starting Date]               AS dateTblStart,
    SetupData.[Date Table Ending Date]                 AS dateTblEnd,
    CAST(NULL AS uniqueidentifier)                     AS tenantID
FROM SetupData;

GO;

CREATE OR ALTER VIEW [bc_finance].[WorkingDays]
AS
WITH Days AS (
    SELECT value AS dayNumber
    FROM (VALUES (1), (2), (3), (4), (5), (6)) AS DayNumbers(value)
),
CompanyList AS (
    SELECT DISTINCT [BC Company] as [BC Company]
    FROM [bc].[General Ledger Setup]
)
SELECT DISTINCT
    TRY_CONVERT(uniqueidentifier, HASHBYTES('MD5', CONCAT('WorkingDay-', CompanyList.[BC Company] , '-', CAST(Days.dayNumber AS NVARCHAR(2))))) AS id,
    CompanyList.[BC Company] ,
    Days.dayNumber
FROM CompanyList
CROSS JOIN Days;

GO;

CREATE OR ALTER VIEW [bc_finance].[Vendors]
AS
SELECT
    [BC Company]          as [BC Company] ,
    [No.]                 AS vendorNo,
    [Name]                AS vendorName,
    [Address]             AS address,
    [Address 2]           AS address2,
    [City]                AS city,
    [Post Code]           AS postCode,
    [County]              AS county,
    [Country/Region Code] AS countryRegionCode,
    [Vendor Posting Group] AS vendorPostingGroup
FROM [bc].[Vendor];

GO;

CREATE OR ALTER VIEW [bc_finance].[Customers]
AS
SELECT
    [BC Company]             as [BC Company] ,
    [No.]                   AS customerNo,
    [Name]                  AS customerName,
    [Address]               AS address,
    [Address 2]             AS address2,
    [City]                  AS city,
    [Post Code]             AS postCode,
    [County]                AS county,
    [Country/Region Code]   AS countryRegionCode,
    [Customer Posting Group] AS customerPostingGroup,
    [Customer Price Group]   AS customerPriceGroup,
    [Customer Disc. Group]   AS customerDiscGroup
FROM [bc].[Customer];

GO;

CREATE OR ALTER VIEW [bc_finance].[AccountCategories]
AS
SELECT
    [BC Company]                  as [BC Company] ,
    [PowerBIAccCategory]      AS powerBIAccCategory,
    [G/L Acc. Category Entry No.] AS glAccCategoryEntryNo,
    [Parent Acc. Category Entry No.] AS parentAccCategoryEntryNo
FROM [bc].[Account Category];


GO;

CREATE OR ALTER VIEW [bc_finance].[GLBudgetEntries]
AS
SELECT
    [Budget Name]      AS budgetName,
    [G/L Account No.]  AS glAccountNo,
    [Date]             AS budgetDate,
    [Amount]           AS budgetAmount,
    [Dimension Set ID] AS dimensionSetID,
    [Entry No.]        AS entryNo
FROM [bc].[GL Budget Entry];

GO;

CREATE OR ALTER VIEW [bc_finance].[VendorLedgerEntries]
AS
SELECT
    VLE.[Entry No.]                      AS vleEntryNo,
    VLE.[Due Date]                       AS vleDueDate,
    VLE.[Open]                           AS vleOpen,
    VLE.[Posting Date]                   AS vlePostingDate,
    VLE.[Document Date]                  AS vleDocumentDate,
    VLE.[Dimension Set ID]               AS vleDimensionSetID,
    VLE.[Closed at Date]                 AS vleClosedAtDate,
    VLE.[Reason Code]                    AS vleReasonCode,
    DVLE.[Entry No.]                     AS dvleEntryNo,
    DVLE.[Posting Date]                  AS dvlePostingDate,
    DVLE.[Ledger Entry Amount]           AS dvleLedgerEntryAmount,
    DVLE.[Entry Type]                    AS dvleEntryType,
    DVLE.[Document Type]                 AS dvleDocumentType,
    DVLE.[Document No.]                  AS dvleDocumentNo,
    DVLE.[Initial Entry Due Date]        AS dvleInitialEntryDueDate,
    DVLE.[Amount (LCY)]                  AS dvleAmountLCY,
    DVLE.[Vendor No.]                    AS dvleVendorNo,
    DVLE.[Application No.]               AS dvleApplicationNo,
    DVLE.[Applied Vend. Ledger Entry No.] AS dvleAppliedVendLedgerEntryNo,
    PurchInvHeader.[No.]                 AS purchInvHeaderDocumentNo,
    PurchInvHeader.[Payment Terms Code]  AS purchInvHeaderPaymentTermsCode,
    PurchInvHeader.[Pmt. Discount Date]  AS purchInvHeaderPmtDiscountDate
FROM [bc].[Vendor Ledger Entry] AS VLE
INNER JOIN [bc].[Detailed Vendor Ledg Entry] AS DVLE
    ON DVLE.[Vendor Ledger Entry No.] = VLE.[Entry No.]
LEFT JOIN [bc].[Purch Inv Header] AS PurchInvHeader
    ON PurchInvHeader.[No.] = DVLE.[Document No.];

GO;

CREATE OR ALTER VIEW [bc_finance].[CustomerLedgerEntries]
AS
SELECT
    CLE.[Entry No.]                       AS cleEntryNo,
    CLE.[Due Date]                        AS cleDueDate,
    CLE.[Open]                            AS cleOpen,
    CLE.[Posting Date]                    AS clePostingDate,
    CLE.[Document Date]                   AS cleDocumentDate,
    CLE.[Dimension Set ID]                AS cleDimensionSetID,
    CLE.[Closed at Date]                  AS cleClosedAtDate,
    CLE.[Reason Code]                     AS cleReasonCode,
    DCLE.[Entry No.]                      AS dcleEntryNo,
    DCLE.[Posting Date]                   AS dclePostingDate,
    DCLE.[Ledger Entry Amount]            AS dcleLedgerEntryAmount,
    DCLE.[Entry Type]                     AS dcleEntryType,
    DCLE.[Document Type]                  AS dcleDocumentType,
    DCLE.[Document No.]                   AS dcleDocumentNo,
    DCLE.[Initial Entry Due Date]         AS dcleInitialEntryDueDate,
    DCLE.[Amount (LCY)]                   AS dcleAmountLCY,
    DCLE.[Customer No.]                   AS dcleCustomerNo,
    DCLE.[Application No.]                AS dcleApplicationNo,
    DCLE.[Applied Cust. Ledger Entry No.] AS dcleAppliedCustLedgerEntryNo,
    SalesInvHeader.[No.]                  AS salesInvHeaderDocumentNo,
    SalesInvHeader.[Payment Terms Code]   AS salesInvHeaderPaymentTermsCode,
    SalesInvHeader.[Pmt. Discount Date]   AS salesInvHeaderPmtDiscountDate
FROM [bc].[Cust Ledger Entry] AS CLE
INNER JOIN [bc].[Detailed Cust Ledg Entry] AS DCLE
    ON DCLE.[Cust. Ledger Entry No.] = CLE.[Entry No.]
LEFT JOIN [bc].[Sales Invoice Header] AS SalesInvHeader
    ON SalesInvHeader.[No.] = DCLE.[Document No.];

GO;

-- Limitations:
-- * The Finance Filter Helper codeunit functions (GenerateFinanceReportDateFilter and
--   GenerateFinanceReportSourceCodeFilter) used by the AL queries cannot be reproduced in
--   Fabric SQL. The above views therefore expose unfiltered datasets.
-- * The "Date Setup" API page retrieves the Azure AD tenant identifier by calling the
--   Azure AD Tenant codeunit. This cannot be implemented in Fabric SQL, so tenantID is
--   returned as NULL.
-- * The PowerBIDimensionSetEntries view uses a deterministic hash of the dimension set ID to
--   emulate the SystemId column because Fabric SQL cannot access the protected PowerBI Flat
--   Dim. Set Entry table that originally generated those identifiers.
-- * The "Date Setup" view assumes Coordinated Universal Time when a mapped time-zone display
--   name cannot be resolved because the Time Zone table is unavailable in Fabric.
-- * The "Working Days" view synthesizes Monday–Saturday entries with deterministic identifiers
--   because the Working Day table is not mirrored into Fabric.
-- * Power BI Account Category is not working because it is internal (protected)